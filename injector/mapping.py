class Module:
    # moduleName = ""     track internally?
    io_dict = dict()     #wirename -> input/output     
    parents = []        #list of other Modules that call this module, easy to move up graph
    module_text = ""     #entire text of module verilog

