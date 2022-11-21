from Module import Module

"""
Generate a verilog module for driving faulty wires
"""
def generate_fault_driver(faults, type = 'FaultDriver'):
    # Generate module text

    module_header = ''
    module_body = ''
    module_footer = '\nendmodule'

    if len(faults) == 1:
        module_header = f'module {type} (\n  input original_values;\n  output faulty_values;\n)'
        module_body += f'\n\n  // fault injection from {faults[0]}\n  assign faulty_values = 0;'
    else:
        module_header = f'module {type} (\n  input  [{len(faults)- 1}:0] original_values;\n  output [{len(faults) - 1}:0] faulty_values;\n)'

        for i, fault in enumerate(faults):
            module_body += f'\n\n  // fault injection from {fault}\n  assign faulty_values[{i}] = 0;'

    module_text = module_header + module_body + module_footer

    return Module(type, module_text)