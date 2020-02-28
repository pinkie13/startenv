##HEADER##
_FILE_=${BASH_SOURCE[0]}
_NOM_=$(basename $_FILE_ .$CLASSE_EXT | tr '.' '_')
echotools ".. Entering $_FILE_"
# File: ##FIL##
# Objet:
# Usage:
# Version:v0.0.0
# Evol:2020-02-09:16:14:fw:
rc=$OK
##HEADER##
#====== fonctions.0000.sms.sh
alias smsgammusend=sms_gammu_send
#====== fonctions.0001.sms.sh
alias smsgammusmsdsend=sms_gammu_smsd_send
alias smsgammusmsdlogs=sms_gammu_smsd_logs
alias smsgammusmsdconfreload=sms_gammu_smsd_conf_reload
#====== fonctions.0003.sms.sh
alias smstoolsmsgneweditor=smstools_msgnew_editor
alias smstoolsmsgsend=smstools_msgsend
alias smstoolsstatus=smstools_status
##FOOTER##
export ${_NOM_}='loaded'
[ $rc -eq $OK ] && echotools ".. Living   $_FILE_ [$rc]" || _err_ $_FILE_ "$messerr [$rc]"
return $rc
##FOOTER##
