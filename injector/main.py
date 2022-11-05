from mapping import Module

if __name__ == '__main__':
    
    with open('alu.v', 'r') as module_f:
        module_text = module_f.read()
    
    alu = Module('alu', module_text)

    print(alu.io)

