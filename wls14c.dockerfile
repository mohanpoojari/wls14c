#Author: Mohan Poojari

ARG REPO
FROM ${REPO}some/tag/centos7

# Build Arguments
# (Put build arguments first and set defaults)
# ARG VERSION=1.0

ARG uid=12009
ARG gid=12009
ARG o_user=oracle
ARG o_group=oinstall

ENV SW_DIR /opt/sw
ENV ORACLE_BASE /u01/app/oracle
ENV ORA_INV_LOC ${ORACLE_BASE}/oraInventory
ENV JAVA_HOME ${ORACLE_BASE}/jdk
ENV MW_HOME ${ORACLE_BASE}/fmw
ENV WL_HOME ${MW_HOME}/wlserver
ENV ORACLE_HOME ${MW_HOME}
ENV PATH $JAVA_HOME/bin:$PATH
ENV USER_MEM_ARGS "-Djava.security.egd=file:/dev/./urandom"
ENV _JAVA_OPTIONS "-Djava.io.tmpdir=/tmp"
ENV JDK_PKG jdk-11.0.13_linux-x64_bin.tar.gz
ENV FMW_PKG fmw_14.1.1.0.0_wls_lite_slim_Disk1_1of1.zip
ENV FMW_JAR fmw_14.1.1.0.0_wls_lite_quick_slim_generic.jar

RUN yum install -y unzip && \
    groupadd -g ${gid} ${o_group} && \
    useradd -u ${uid} -g ${gid} -m -s /bin/bash ${o_user} && \
    mkdir -p ${ORACLE_BASE} && \
    mkdir -p ${SW_DIR} && \
    mkdir -p ${ORA_INV_LOC} && \
    mkdir -p ${JAVA_HOME} && \
    mkdir -p ${MW_HOME} && \
    chown -R ${o_user}:${o_group} ${SW_DIR} ${ORACLE_BASE} ${MW_HOME} ${JAVA_HOME} && \
    echo "inventory_loc=${ORA_INV_LOC}" > /etc/oraInst.loc && \
    echo "inst_group=${o_group}" >> /etc/oraInst.loc

#Download Oracle WebLogic Server 14.1.1.0.0 has certifications with Oracle JDK 11.0.13.0.0.
#Place the software under software directory
COPY resources/software/${JDK_PKG} ${SW_DIR}
#Download https://download.oracle.com/otn/nt/middleware/14c/14110/fmw_14.1.1.0.0_wls_lite_slim_Disk1_1of1.zip
#Place the software under software directory
COPY resources/software/${FMW_PKG} ${SW_DIR}
COPY resources/software/responseFile.txt ${SW_DIR}

WORKDIR ${ORACLE_BASE}
USER ${o_user}

RUN tar xvf ${SW_DIR}/${JDK_PKG} -C ${JAVA_HOME} --strip-components=1 && \
    unzip ${SW_DIR}/${FMW_PKG} -d ${SW_DIR} && \
    sed -i 's/^securerandom.source=.*/securerandom.source=file:\/dev\/.\/urandom\n/' $JAVA_HOME/conf/security/java.security

#Install WLS software
RUN java -jar ${SW_DIR}/${FMW_JAR} ORACLE_BASE=${ORACLE_BASE} ORACLE_HOME=${ORACLE_HOME} JAVA_HOME=${JAVA_HOME} -responseFile ${SW_DIR}/responseFile.txt -invPtrLoc /etc/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation
