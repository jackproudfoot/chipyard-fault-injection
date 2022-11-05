class Module:
    # moduleName = ""     track internally?
    ioDict = dict()     #wirename -> input/output     
    parents = []        #list of other Modules that call this module, easy to move up graph
    moduleText = ""     #entire text of module verilog

