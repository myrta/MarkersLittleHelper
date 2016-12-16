# Author: Myrta Gruening <info@myrta.eu>.

"""

This python script is part of the "Marker\'s Little Helper" toolkit.
The script:

    - reads a cvs file with the list of students 
    - reads a cvs file with the marking scheme 
    - reads a cvs file with the details of the course/module and test type  
    - creates a xml file with the fill-in class register

The cvs file with the list of students should have the following format:
student name, student surname, student id, student email 

The cvs file with the marking scheme should have the following format:
criterion, maximum available marks

The cvs file with the module detail should have the following format:
institution, module code, module name, teacher name, teacher email, assessment type

The xml has the following structure:

<REGISTER>
<MODULE>
  <INSTITUTION/><MODULE_CODE/><MODULE_NAME/><TEACHER/><TEACHER_EMAIL/>
</MODULE>
<TEST><TYPE/><AVAILABLE_MARKS></TEST>
<STUDENT>
 <DATA>
   <NAME/><SURNAME/><ID/><EMAIL/>
 </DATA>
 <MARKS><PNT/></MARKS>
 <COMMENT/>
</STUDENT>
</REGISTER>
"""

import csv
import argparse
import xml.etree.ElementTree as ET
import lxml.etree as ET

parser=argparse.ArgumentParser(description='Marker\'s Little Helper: python script to create the register xml file')
parser.add_argument('--dirin', '-i', metavar='path_to_dir', type=str, default='./',
                    help='set the directory containing the cvs files [default: this dir]')
parser.add_argument('--scheme', '-s', metavar='filename', type=str, default='marking_scheme.csv',
                   help='set the csv file name with the marking scheme [default: marking_scheme.csv]')
parser.add_argument('--slist', '-l', metavar='filename', type=str, default='students_list.csv',
                   help='set the csv file name with the students list [default: students_list.csv]')
parser.add_argument('--mod', '-m', metavar='filename', type=str, default='module_details.csv',
                   help='set the csv file name with the module details [default: module_details.csv]')
parser.add_argument('--dirout', '-o', metavar='path_to_dir', type=str, default='./',
                    help='set the directory where to output the xml file [default: this dir]')
parser.add_argument('--xml', '-x', metavar='filename', type=str, default='Class_Register.xml',
                   help='set the xml file name [default: Class_Register.xml]')

args = parser.parse_args()
ofile=args.dirout+"/"+args.xml
ifile_scheme=args.dirin+"/"+args.scheme
ifile_mod=args.dirin+"/"+args.mod
ifile_list=args.dirin+"/"+args.slist

register = ET.Element('REGISTER')
register.append(ET.Comment('Generated by makeclassregister.py for Marker\'s Little Helper'))

module=ET.SubElement(register, 'MODULE')
test=ET.SubElement(register, 'TEST')

with open(ifile_mod, 'rt') as f:
    module_details = csv.reader(f)
    for row in module_details:
        dep_name, m_code, m_name, t_name, t_email, T_type = row
        inst = ET.SubElement(module, 'INSTITUTION')
        inst.text=str(dep_name).strip()
        module_code = ET.SubElement(module, 'MODULE_CODE')
        module_code.text=str(m_code).strip()
        module_name = ET.SubElement(module, 'MODULE_NAME')
        module_name.text=str(m_name).strip()
        teacher_name = ET.SubElement(module, 'TEACHER')
        teacher_name.text=str(t_name).strip()
        teacher_email = ET.SubElement(module, 'TEACHER_EMAIL')
        teacher_email.text=str(t_email).strip()
        test_type = ET.SubElement(test, 'TYPE')
        test_type.text=str(T_type).strip()
        
with open(ifile_scheme, 'rt') as f:
    mark_scheme = csv.reader(f)
    criteria = 0
    comm = []
    maxpoints = 0
    for row in mark_scheme:
        m_comm, m_points = row
        comm.append(str(m_comm) + ': '+ str(m_points) + ' mark(s)')
        maxpoints += int(m_points)
        criteria += 1

available_marks = ET.SubElement(test, 'AVAILABLE_MARKS')
available_marks.text=str(maxpoints).strip()
                
with open(ifile_list, 'rt') as f:
    student_list = csv.reader(f)
    for row in student_list:
        s_name, s_sname, s_id, s_email = row
        student = ET.SubElement(register, 'STUDENT')
        data = ET.SubElement(student, 'DATA')
        name = ET.SubElement(data, 'NAME')
        name.text=str(s_name).strip()
        surname = ET.SubElement(data, 'SURNAME')
        surname.text=str(s_sname).strip()
        stid = ET.SubElement(data, 'ID')
        stid.text=str(s_id).strip()
        email = ET.SubElement(data, 'EMAIL')
        email.text = str(s_email).strip()
        marks = ET.SubElement(student, 'MARKS')
        for criterion in range(0,criteria):
            pnts = ET.SubElement(marks,'PNT',{'type':str(criterion+1), 'obj':str(comm[criterion])})
            pnts.text=str(0)
#            marks.append(ET.Comment(comm[criterion]))
        remarks = ET.SubElement(student, 'COMMENT')
        remarks.text = 'No comment (use \LaTeX for formulae)'

xmlstr = ET.tostring(register, pretty_print=True)
with open(ofile, "w") as f:
    f.write(xmlstr)