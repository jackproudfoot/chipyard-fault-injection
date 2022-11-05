class Module:

    def __init__(self, name, module_text, parents = [], children = []):
        self.name = name
        self.module_text = module_text
        self.io = dict()
        self._parents = parents
        self._children = children

        if module_text == '':
            print('Cannot initialize module ({}) without module text.'.format(name))
            exit(1)

        self._parse_io()

    def add_parents(self, parents):
        self._parents += parents

    def add_children(self, children):
        self._children += children

    def _parse_io(self):
        pass

    def __str__(self):
        return '== {} ==\n\tParents: {}\n\tChildren: {}'.format(
            self.name, 
            [parent.name for parent in self._parents], 
            [child.name for child in self._children]
        )