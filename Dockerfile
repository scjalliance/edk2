# Specify the distribution
ARG DISTRO=debian10

# Start with the prerequisite parent image for the selected distribution
FROM scjalliance/edk2:prereqs-${DISTRO}

# Specify which edk2 tag to use
ARG TAG=edk2-stable202002

# Specify some labels
LABEL maintainer="Joshua Sjoding <joshua.sjoding@scjalliance.com>" \
      description="Build environment for the TianoCore EDK II project running on ${DISTRO}. Follows the ${TAG} tag." \
      distro="${DISTRO}" \
      edk2.tag="${TAG}"

# Specify the path to the base tools
ENV EDK_TOOLS_PATH=/opt/src/edk2/BaseTools

# Prepare a source directory
WORKDIR /opt/src

# Perform a clone and the then build the tools (we exclude the git history which saves a few hundred megabytes of space)
RUN git clone --branch ${TAG} --single-branch --depth 1 https://github.com/tianocore/edk2 && make -C edk2/BaseTools

# Configure the build
WORKDIR /opt/src/edk2/Conf

RUN touch target.txt && \
    echo "MAX_CONCURRENT_THREAD_NUMBER = 0" >> target.txt && \
    echo "BUILD_RULE_CONF              = Conf/build_rule.txt" >> target.txt && \
    echo "TOOL_CHAIN_CONF              = Conf/tools_def.txt" >> target.txt && \
    echo "TOOL_CHAIN_TAG               = GCC83" >> target.txt

# Run the setup script
WORKDIR /opt/src/edk2

RUN ["/bin/bash", "-c", "source edksetup.sh"]

# Support interactive usage
CMD ["/bin/bash"]
