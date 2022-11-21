import random
import re
import copy


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
    def __init__(self, type, module_text):
        self.type = type
        self.module_text = module_text

        self.io = dict()     
        self.wires = []


        if module_text == '':
            print('Cannot initialize module ({}) without module text.'.format(type))
            exit(1)

        self._parse_io()
        self.extract_wires()

    def extract_wires(self):
        wires = re.findall(r'(wire|reg)\s+(?:\[(\d+:\d)\])?\s*(\w+)(?:;|(?: = .+?;))(?: \/\/ @\[(.*?)\])?', self.module_text, flags=re.S)

        for wire in wires:
            self.wires.append(Wire(wire[0], wire[1], wire[2], wire[3]))



    '''
    Injects fault into module wires
    '''
    def inject_fault(self, sample_wire, fault_input_wire, fault_output_wire, bus_index = None):
        # name of placeholder wire for original fault-free value 
        sample_wire_original = f'{sample_wire}_original'

        # match case "wire wire_name =" or "assign wire_name = "
        groups = re.findall(rf'(wire|assign)(\s+(?:\[(\d+:\d)\])?\s*){sample_wire}( = )', self.module_text)
        if len(groups) > 0:
            if len(groups) > 1:
                print(f'\033[93mWarning: found more than one declaration for wire {sample_wire}... using the first.\033[0m')


            # circuit for injection logic and the substition pattern
            injection_circuit = ''
            substitution = ''

            # format the placeholder for the original wire value
            original_placeholder = f'wire{groups[0][1]}{sample_wire_original}{groups[0][3]}'

            # if the wire is a bus i.e. test[4:0] only inject fault in a single bit
            bounds_string = groups[0][1].strip()
            if (bounds_string != ''):
                bounds = bounds_string[1:-1].split(':')
                faulty_index = bus_index if bus_index != None else random.randrange(int(bounds[1]), int(bounds[0]))

                # determine concatination pattern for injecting faulty bit based on indices
                bus_concatination = ''
                if faulty_index < int(bounds[0]):
                    bus_concatination += f'{sample_wire_original}[{bounds[0]}, {faulty_index}]'
                bus_concatination += f', {sample_wire}_faultybit'
                if faulty_index > int(bounds[1]):
                    bus_concatination += f', {sample_wire_original}[{faulty_index-1}, {bounds[1]}]'

                injection_circuit = f'wire {sample_wire}_faultybit = {fault_input_wire};\n {groups[0][0]} {sample_wire} = {{{bus_concatination}}}'
                substitution = f'{injection_circuit} // fault injection \n  assign {fault_output_wire} = {sample_wire_original}[{faulty_index}]; // direct original value to output \n  {original_placeholder}'
            
            # else the wire is a single bit
            else:
                injection_circuit = f'{groups[0][0]} {sample_wire} = {fault_input_wire};'
                substitution = f'{injection_circuit} // fault injection \n  assign {fault_output_wire} = {sample_wire_original}; // direct original value to output \n  {original_placeholder}'


            # substitute the module text with the fault-controllable module
            self.module_text = re.sub(rf'(?:wire|assign)(\s+(?:\[(\d+:\d)\])?\s*){sample_wire}( = )', substitution, self.module_text)
            return

        # match case for regs "reg_name <=" or "reg_name = "
        groups = re.findall(rf'{sample_wire}( (?:=|<=) )', self.module_text)
        if len(groups) > 0:
            
            # first go through and replace all assignments with original
            for group in groups:
                self.module_text = re.sub(rf'{sample_wire}{group[0]} ', rf'{sample_wire_original}{group[0]} ', self.module_text)
            

            # create reg for original holding value and add fault injection
            groups = re.findall(rf'reg(\s+(?:\[(\d+:\d)\])?\s*){sample_wire};', self.module_text)
            if len(groups) > 0:
                
                # circuit for injection logic and the substition pattern
                injection_circuit = ''
                substitution = ''
                original_placeholder = f'reg{groups[0][0]}{sample_wire_original}'

                # if the reg is a bus, only inject fault into single bit of bus
                bounds_string = groups[0][1]
                if (bounds_string != ''):
                    bounds = bounds_string.split(':')
                    faulty_index = random.randrange(int(bounds[1]), int(bounds[0]))

                    # determine concatination pattern for injecting faulty bit
                    bus_concatination = ''
                    if faulty_index < int(bounds[0]):
                        bus_concatination += f'{sample_wire_original}[{bounds[0]}, {faulty_index}]'
                    bus_concatination += f', {sample_wire}_faultybit'
                    if faulty_index > int(bounds[1]):
                        bus_concatination += f', {sample_wire_original}[{faulty_index-1}, {bounds[1]}]'

                    injection_circuit = f'wire {sample_wire}_faultybit = {fault_input_wire};\nwire{groups[0][0]}{sample_wire} = {{{bus_concatination}}}'
                    substitution = f'{injection_circuit} // fault injection \n  assign {fault_output_wire} = {sample_wire_original}[{faulty_index}]; // direct original value to output \n  {original_placeholder}'
                    
                else:
                    injection_circuit = f'wire {sample_wire} = {fault_input_wire};'
                    substitution = f'{injection_circuit} // fault injection\n  assign {fault_output_wire} = {sample_wire_original}; // direct original value to output \n {original_placeholder}'

                self.module_text = re.sub(rf'reg(\s+(?:\[(\d+:\d)\])?\s*){sample_wire};', substitution, self.module_text)
                return


            else:
                print(f'\033[91mError: could not find where reg is declared {sample_wire}.\033[0m')
                exit(1)

            
        print(f'\033[91mError: could not inject fault into wire {sample_wire}.\033[0m')
        
        
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

    '''
    Given some wire and bit, checks if that is a valid bit for that wire's bounds.
    '''
    def check_wire_bit(self, wire_name, bit_num):
        if not self.is_valid_wire(wire_name):
            print("invalid wire name")
            return
        for wire in self.wires:
            if wire.name == wire_name:
                if wire.bounds is None:
                    return True         #figure if the wire is 1 bit, we will just ignore whatever bit position the user said they wanted to modify and just modify the single bit of the wire
                return bit_num <= wire.bounds[0] and bit_num >= wire.bounds[1]

    '''
    Returns a copy of the module
    '''
    def copy(self):
        return copy.deepcopy(self)

    '''
    String representation for the module class
    '''
    def __str__(self):
        return self.type