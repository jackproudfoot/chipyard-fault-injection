
import re

class Wire:
    def __init__(self, type, bounds, name, chisel_ref):
        self.type = type
        self.name = name
        self.chisel_ref = chisel_ref

        if bounds == '':
            self.bounds = None
        else:
            bound_parts = bounds.split(':')
            self.bounds = (int(bound_parts[0]), int(bound_parts[1]))

    def __str__(self):


        return '{} {} {}'.format(self.type, self.name, '[{}:{}]'.format(self.bounds[0], self.bounds[1]) if self.bounds else '')

class Module:
    #def __init__(self, name, module_text, parents = None, children = None):
    def __init__(self, type, module_text):
        self.type = type
        self.module_text = module_text

        self.io = dict()     
        self.wires = []


        if module_text == '':
            print('Cannot initialize module ({}) without module text.'.format(type))
            exit(1)

        self._parse_io()

    def extract_wires(self):
        wires = re.findall(r'(wire|reg)\s+(?:\[(\d+:\d)\])?\s*(\w+)(?:;|(?: = .+?;))(?: \/\/ @\[(.*?)\])?', self.module_text, flags=re.S)

        for wire in wires:
            self.wires.append(Wire(wire[0], wire[1], wire[2], wire[3]))



    def _parse_io(self):
        # use regex to extract references to inputs and outputs
        io = re.findall(r'((?:input)|(?:output))\s+(?:\[\d+:\d+\])?\s*(\w+)', self.module_text)

        for module_input in io:
            self.io[module_input[1]] = module_input[0]

    '''
    String representation for the module class
    '''
    def __str__(self):
        return self.type