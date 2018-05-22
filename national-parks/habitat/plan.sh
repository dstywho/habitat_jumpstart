pkg_name=national-parks
pkg_description="A sample JavaEE Web app deployed in the Tomcat8 package"
pkg_origin=habitat_workshop
pkg_version=6.3.0
pkg_maintainer="dstywho@gmail.com>"
pkg_license=('Apache-2.0')
pkg_deps=(core/tomcat8 core/jre8 core/mongo-tools)
pkg_build_deps=(core/jdk8/8u131 core/maven)
pkg_svc_user="root"
pkg_binds=(
  [database]="port"
)
# pkg_exports=(
#   [port]=tomcat_port
# )
# pkg_exposes=(port)

do_prepare()
{
    export JAVA_HOME=$(hab pkg path core/jdk8)
}

do_build()
{
    cp -r $PLAN_CONTEXT/../ $HAB_CACHE_SRC_PATH/$pkg_dirname
    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}
    mvn package
}

do_install()
{
    # cp /hab/cache/src/national-parks-6.3.0/target/national-parks.war /hab/pkgs/habitat_workshop/national-parks/6.3.0/20180522184801
    cp ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/target/${pkg_name}.war ${PREFIX}/
    mkdir -p ${PREFIX}/config
    # cp /hab/pkgs/core/tomcat8/8.5.9/20170514144202 /hab/pkgs/habitat_workshop/national-parks/6.3.0/2018052218480/config
    cp $(hab pkg path core/tomcat8)/config/conf_server.xml ${PREFIX}/config/
    cp ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/data/national-parks.json ${PREFIX}/
}
