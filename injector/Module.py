import random
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



    '''
    Injects fault into module wires
    '''
    def inject_fault(self):
        #sample_wire = random.sample(self.wires, 1)[0]

        sample_wire = '_r_valids_0_T'

        wire_type = 'unknown'

        # match case "wire wire_name ="
        if re.search(rf'wire\s+(?:\[(\d+:\d)\])?\s*{sample_wire} = ', self.module_text) != None:
            wire_type = 'wire inline'
        else:
            print('not found')

    '''
    Parse inputs/outputs from the module
    '''
    def _parse_io(self):
        # use regex to extract references to inputs and outputs
        io = re.findall(r'((?:input)|(?:output))\s+(?:\[\d+:\d+\])?\s*(\w+)', self.module_text)

        for module_input in io:
            self.io[module_input[1]] = module_input[0]


    '''
    Given some wire name, check if that is a known wire for this module.
    '''
    def is_valid_wire(self, wire_name):
        for wire in self.wires:
            if wire.name ==  wire_name:
                return True
        return False

    
    #test that strings are passed by value
    def create_faulty_copy(self):
        return Module('{}_FAULTY'.format(self.type), self.module_text)

    '''
    String representation for the module class
    '''
    def __str__(self):
        return self.type