
import re

class Module:
    #def __init__(self, name, module_text, parents = None, children = None):
    def __init__(self, name, module_text):
        self.type = name
        self.module_text = module_text
        self.io = dict()

        # self._parents = parents or list()
        # self._children = children or list()
        self._parents = list()
        self._children = list()

        if module_text == '':
            print('Cannot initialize module ({}) without module text.'.format(name))
            exit(1)

        self._parse_io()

    '''
    Add list of references to parent modules
    '''
    def add_parents(self, parents):
        #self._parents += parents
        self._parents.extend(parents)

    '''
    Add list of references to children modules
    '''
    def add_children(self, children):
        #self._children += children
        self._children.extend(children)


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
        return '== {} ==\n\tParents: {}\n\tChildren: {}'.format(
            self.type, 
            [parent.name for parent in self._parents], 
            [child.name for child in self._children]
        )