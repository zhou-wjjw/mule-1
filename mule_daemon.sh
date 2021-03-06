#!/bin/sh
#
# mule     Startup script for mule
#
# chkconfig:   - 64 36
# description: Startup script for mule
# processname: lua
# config:      /etc/sysconfig/mule
# pidfile:     /var/run/mule/mule.pid

# Source function library
. /etc/rc.d/init.d/functions

prog="mule.lua"
stop_token="nomoremule"
mule_port=8980
muleuser=<mule-user> # set the actual user
luaexe=/usr/bin/lua
luarocks=/usr/local/bin/luarocks
muleuser=`ls -l -H /etc/init.d/mule_daemon | awk '{ print $3}'`
shareddir=/home/$muleuser/mule/shared
currentdir=/home/$muleuser/mule/current
#export FCGI_CHILDREN FCGI_MAX_REQUESTS
RETVAL=0

start() {
  echo "starting $prog: "
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib;
  eval `$luarocks path`
  cmd="cd $currentdir && $luaexe $currentdir/mule.lua -l $shareddir/log/mule_http_daemon.log -d $shareddir/db/mule.tcb -t 0.0.0.0:$mule_port -x $stop_token &"
  su $muleuser sh -c "$cmd"
  RETVAL=$?
  if [ $RETVAL -eq 0 ]
  then
      echo_success
  else
      echo_failure
  fi
  echo
  return $RETVAL
}

stop() {

  for i in 1 2 3; do
      echo -n $"stopping $prog (attempt: $i)"
      curl --connect-timeout 10 -m 20 http://127.0.0.1:$mule_port/stop?token=$stop_token
      sleep 4
      curl http://127.0.0.1:$mule_port
      if [ $?==7 ]; then
          echo -e "\nsuccessfully stopped"
          return 0
      fi
  done

  echo_failure
  return 1
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo $"usage: $0 {start|stop|restart}"
    RETVAL=1
esac

exit $RETVAL
