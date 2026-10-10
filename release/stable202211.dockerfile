# Specify which version of the debian distribution to use.
ARG DISTRO=debian12

# Start with the prerequisite parent image for the selected distribution.
FROM scjalliance/edk2:prereqs-${DISTRO}

# Inherit arguments.
ARG DISTRO

# Specify which EDK II tag to use.
ARG TAG=stable202211

# Apply some labels to the image.
LABEL maintainer="Joshua Sjoding <joshua.sjoding@scjalliance.com>" \
      description="Build environment for the TianoCore EDK II project running on ${DISTRO}. Based on the edk2-${TAG} tag." \
      distro="${DISTRO}" \
      edk2.tag="${TAG}"

# Specify the path to the base tools.
ENV EDK_TOOLS_PATH=/opt/src/edk2/BaseTools

# Prepare a source directory.
WORKDIR /opt/src

# Perform a shallow clone of the source and its submodules. Excluding the full git history saves a few hundred megabytes of space.
RUN git clone --branch edk2-${TAG} --single-branch --depth 1 https://github.com/tianocore/edk2 && cd edk2 && git submodule update --init --recursive

# Move into the cloned EDK II source.
WORKDIR /opt/src/edk2

# Build the base tools.
RUN make -C BaseTools

# Configure the build target.
WORKDIR /opt/src/edk2/Conf

RUN touch target.txt && \
    echo "MAX_CONCURRENT_THREAD_NUMBER = 0" >> target.txt && \
    echo "BUILD_RULE_CONF              = Conf/build_rule.txt" >> target.txt && \
    echo "TOOL_CHAIN_CONF              = Conf/tools_def.txt" >> target.txt && \
    echo "TOOL_CHAIN_TAG               = GCC5" >> target.txt

# Run the EDK II setup script that prepares the environment.
WORKDIR /opt/src/edk2

RUN ["/bin/bash", "-c", "source edksetup.sh"]

# Support interactive usage
CMD ["/bin/bash"]
