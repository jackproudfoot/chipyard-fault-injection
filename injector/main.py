from mapping import Module

if __name__ == '__main__':
    mod = Module('test', 'test module')

    mod2 = Module('test2', 'test module 2', parents = [mod])

    mod.add_children([mod2])

    print(mod)
    print(mod2)