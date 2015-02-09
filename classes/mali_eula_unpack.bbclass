python do_unpack() {
    eula = d.getVar('ACCEPT_MALI_EULA', True)
    pkg = d.getVar('PN', True)
    if eula == None:
        bb.fatal("To use '%s' you need to accept the END USER LICENCE AGREEMENT. "
                 "Please read it and in case you accept it, add: "
                 "ACCEPT_MALI_EULA = \"1\" to your local.conf." % (pkg))
    elif eula == '1':
        bb.warn("END USER LICENCE AGREEMENT for %s has been accepted." % pkg)
    else:
        bb.fatal("To use %s you need to accept the END USER LICENCE AGREEMENT." % pkg)

    try:
        bb.build.exec_func('base_do_unpack', d)
    except:
        raise
}
