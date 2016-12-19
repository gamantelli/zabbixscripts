#!/usr/bin/python -W ignore::DeprecationWarning
import sys, os, xmpp, getopt, syslog
 
def main(argv):
    login="zabbixflexcontact@gmail.com"
    pwd="z4bb1xfl3x"
    _debug = 0
 
    if len(sys.argv) < 3:
        usage()
        sys.exit(2)
 
    #log dos parametros recebidos
    #log(' '.join(sys.argv[1:]))
 
    rcptto=None
    subject=None
    msg=None
 
    rcptto=sys.argv[1]
    subject=sys.argv[2]
    msg=sys.argv[3]
 
    if subject != None and msg == None:
        msg = subject;
        subject = None;
 
    if rcptto == None or msg == None:
        usage()
        sys.exit(2)
 
    log(msg)
 
    print "Starting process..."
 
    def presenceHandler(conn, presence):
        if presence:
            if presence.getType() == "subscribe":
                cl.PresenceManager.ApproveSubscriptionRequest(pres.From)
 
    login=xmpp.protocol.JID(login)
 
    if _debug == 1:
        cl=xmpp.Client(login.getDomain())
    else:
        cl=xmpp.Client(login.getDomain(),debug=[])
 
    print "Connecting..."
    if cl.connect( server=('google.com',5222)  ) == "":
            print "not connected"
            sys.exit(0)
 
    print "Authentication..."
    if cl.auth(login.getNode(),pwd) == None:
            print "authentication failed"
            sys.exit(0)
 
    # habilita que este cliente aceite automaticamente requisicao de contato
    #cl.RegisterHandler('presence',presenceHandler)
    #cl.sendInitPresence()
 
    print "Add user "+rcptto
    pres = xmpp.Presence(to=rcptto, typ='subscribe')
    cl.send(pres)
 
    print "Sending message to "+rcptto
    cl.send(xmpp.protocol.Message(rcptto,msg,"chat"))
    cl.disconnect()
 
    print "Message Sent!"
 
def usage():
    print "Usage:  {-d} [to] [subject] [body]"
    print ""
    print "Options:"
    print "  [to]   destination of messages"
    print "  [subject]  subect of message"
    print "  [body] destination of messages"
 
def log(text):
    syslog.syslog(syslog.LOG_ERR, text)
 
if __name__ == "__main__":
    main(sys.argv[1:])
