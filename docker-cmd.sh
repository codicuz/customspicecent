#!/bin/bash

DINAME="centos-tail:latest"
DCNAME="ctail"
HOSTNAME="c-tail.myhost.lan"

NO_ARGS=0
E_OPTERR=65

if [ $# -eq "$NO_ARGS" ]
then
  printf "Отсутствуют аргументы. Должен быть хотя бы один аргумент.\n"
  printf "Использование: $0 {-build|-rmi|-none|-rmfa|-run|-restart|-rmf|-exec|-exec0|-logsf}\n"
  printf " $0 -run - создание и запуск контейнера $DCNAME\n" 
  printf " $0 -restart - перезапуск контейнера $DCNAME\n"
  printf " $0 -rmf - удаление контейнера $DCNAME (docker rm -f $DCNAME)\n"
  printf " $0 -rmfa - удаление всех контейнеров, в том числе и запущенных (docker rm -f \$(dokcer ps -a -q)\n"
  printf " $0 -exec - подключиться к контейнеру $DCNAME (docker exec -it $DCNAME /bin/bash)\n"
  printf " $0 -exec0 - подключиться к контейнеру $DCNAME из-под пользователя uid 0 (docker exec -it -u 0 $DCNAME /bin/bash)\n"
  printf " $0 -logsf - вывод служебных сообщений контейнера $DCNAME (docker logs -f $DCNAME)\n"
  printf " $0 -build - сборка образа $DINAME\n"
  printf " $0 -rmi - удаление образа $DINAME\n"
  printf " $0 -none - удаление образов NONE\n"
  exit $E_OPTERR
fi

while :; do
	case "$1" in
	-build)
	  docker build -t $DINAME .
	 ;;
	-rmi)
	  docker rmi $DINAME
	 ;;
	-none)
	  docker rmi $(docker images -f "dangling=true" -q)
	 ;;
	-rmfa)
	  docker rm -f $(docker ps -a -q)
	 ;;
	-run)
	  docker run -itd \
	  --hostname $HOSTNAME \
	  -p 5907:5900 \
	  --name $DCNAME \
	  $DINAME
	 ;;
	-restart)
	  docker restart $DCNAME
	 ;;
	-rmf)
	  docker rm -f $DCNAME
	 ;;
	-exec)
	  docker exec -it $DCNAME /bin/bash
	 ;;
	-exec0)
	  docker exec -it -u 0 $DCNAME /bin/bash
	 ;;
	-logsf)
	  docker logs -f $DCNAME
	 ;;
	--)
	  shift
	 ;;
	?* | -?*)
	  printf 'ПРЕДУПРЕЖДЕНИЕ: Неизвестный аргумент (проигнорировано): %s\n' "$1" >&2
	 ;;
	*)
	  break
	esac
	shift
done

exit 0
