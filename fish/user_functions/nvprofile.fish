
function nvprofile
    touch /tmp/startup.log
    rm /tmp/startup.log
    $EDITOR --startuptime /tmp/startup.log +qa
    $EDITOR /tmp/startup.log -c "%!sort -k2nr" -c w
end
