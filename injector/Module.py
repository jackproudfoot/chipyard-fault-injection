
import re

class Module:
    #def __init__(self, name, module_text, parents = None, children = None):
    def __init__(self, type, module_text):
        self.type = type
        self.module_text = module_text
        self.io = dict()     

        if module_text == '':
            print('Cannot initialize module ({}) without module text.'.format(type))
            exit(1)

        self._parse_io()

    def _parse_io(self):
        # use regex to extract references to inputs and outputs
        inputs = re.findall(r'input\s+(?:\[\d+:\d+\])?\s*(\w+)', self.module_text)
        outputs = re.findall(r'output\s+(?:\[\d+:\d+\])?\s*(\w+)', self.module_text)

        for module_input in inputs:
            self.io[module_input] = 'input'

        for module_output in outputs:
            self.io[module_output] = 'output'
    

    '''
    String representation for the module class
    '''
    def __str__(self):
        return self.type