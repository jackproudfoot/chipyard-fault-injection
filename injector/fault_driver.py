from Module import Module

"""
Generate a verilog module for driving faulty wires
"""
def generate_fault_driver(faults, name = 'FaultDriver'):
    # Generate module text

    module_header = ''
    module_body = ''
    module_footer = '\nendmodule'

    if len(faults) == 1:
        module_header = f'module {name} (\n  input original_value;\n  output faulty_value;\n)'
        module_body += f'\n\n  // fault injection from {faults[0]}\n  assign faulty_value = 0;'
    else:
        module_header = f'module {name} (\n  input  [{len(faults)- 1}:0] original_value;\n  output [{len(faults)}:0] faulty_value;\n)'

        for i, fault in enumerate(faults):
            module_body += f'\n\n  // fault injection from {fault}\n  assign faulty_value[{i}] = 0;'

    module_text = module_header + module_body + module_footer

    return Module(name, module_text)