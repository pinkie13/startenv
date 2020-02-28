##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: alias.0000.sms.sh
# Objet:
# Usage:
# Version:V0.0.0
# Evol:2020-02-04_1754:fw:
rc=$OK
##HEADER##

# == ATTENTION: Raccourcis sur fonctions de la classe DANS alias.sms.shortfuncname.sh

# == GLOBAL
alias smsdev="ls -l /dev |grep -e 'ACM' -e 'rfcomm'  "

# == GAMMU
if [ "$GAMMU_ACTIVATED" == 'on' ] ; then
alias smsgammuconfv="v $GAMMU_CONF"
fi
# == GAMMU-SMSD
if [ "$GAMMUSMSD_ACTIVATED" == 'on' ] ; then
alias smsgammusmsdconfv="v $GAMMU_SMSD_CONF"
alias smsdstatus="systemctl status gammu-smsd.service"
fi
# == SMSTOOLS
if [ "$SMSD_ACTIVATED" == 'on' ] ; then
# .. cd ...
alias cdsmstoolsspool="cd $SMSDPSPOOL"
alias cdsmstoolslog="cd $SMSDPLOG"
alias cdsmstoolsatelier="cd $SMSDPATELIER"
# .. divers
alias checkhandlerlogtail="tail $checkhandlerlog"
alias smstoolsconfv="v $SMSDFCONF"
alias smstoolsconfcat="cat $SMSDFCONF"
alias smstoolsservice='sudo service smstools'
fi
##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
