__author__ = 'root'

import imp,os,sys,traceback

PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append('%s/../../common/python'%PATH)
import init_script

import swarm.error
import desert.errors
import string
import desert.base



class Indent:
	def __init__(self):
		self.indents = 0

	def inc(self,n=1):
		self.indents += n
		return self

	def dec(self,n=1):
		self.indents -=n
		if self.indents < 0 :
			self.reset()
		return self

	def reset(self):
		self.indents = 0
		return self

	def str(self):
		return '\t'*self.indents

	def __str__(self):
		return self.str()

class code_writer_base:
	def __init__(self):
		self.indent = Indent()
		self.content = ''

	def CR(self,n=1):
		self.content += '\n'*n
		return self

	def idt_inc(self):
		self.indent.inc()
		self.content += str(self.indent)
		return self

	def idt_dec(self):
		self.indent.dec()
		self.content += str( self.indent )
		return self

	@property
	def comment_chars(self):
		return '//'


	def line_comment(self,text):
		self.content += self.comment_chars + ' ' + text
		return self

	def scope_begin(self):
		self.content+= '{'
		return self

	def scope_end(self):
		self.content += '}'
		return self

	def class_def(self,clsname):
		self.content += 'class %s'%clsname
		return self

	def line_text(self,text):
		self.content += text
		return self

class code_writer_java(code_writer_base):
	def __init__(self):
		code_writer_base.__init__(self)


	def code_write(self,module_name,entities):
		self.class_def(module_name).scope_begin().CR()
		for ent in entities:
			self.idt_inc()
			self.line_text( 'public final static int %s = %s; '%(ent.name,ent.code)).line_comment(ent.msg).CR()
			self.idt_dec()
		self.idt_dec().scope_end()
		f = open('%s/%s.java'%(output_path,module_name),'w')
		# print self.content
		f.write( self.content.encode('utf-8'))
		f.close()
		return self


class code_writer_js(code_writer_base):
	def __init__(self):
		code_writer_base.__init__(self)

	def class_def(self,clsname):
		self.content+='var '

	def code_write(self,module_name,entities):
		self.class_def(module_name).scope_begin().CR()
		for ent in entities:
			self.idt_inc()
			self.line_text( 'public final static int %s = %s; '%(ent.name,ent.code)).line_comment(ent.msg).CR()
			self.idt_dec()
		self.idt_dec().scope_end()
		f = open('%s/%s.java'%(output_path,module_name),'w')
		# print self.content
		f.write( self.content.encode('utf-8'))
		f.close()
		return self

class code_writer_objc(code_writer_base):
	def __init__(self):
		code_writer_base.__init__(self)

	def code_write_inc_begin(self,module_name):
		self.line_text('#ifndef __%s__'%module_name).CR()
		self.line_text('#define __%s__'%module_name).CR(2)
		return self

	def code_write_inc_end(self,module_name):
		self.line_text('#endif  //__%s__'%module_name)
		return self

	def code_write(self,module_name,entities,inc_pragma = True):
		if inc_pragma:
			self.code_write_inc_begin(module_name)

		# self.class_def(module_name).scope_begin().CR()
		for ent in entities:
			# self.idt_inc()
			self.line_text( 'int %s_%s = %s; '%(module_name,ent.name,ent.code)).line_comment(ent.msg).CR()
			# self.idt_dec()
		# self.idt_dec().scope_end()
		self.CR()

		if inc_pragma:
			self.code_write_inc_end(module_name)
		return self



class XObject:
	def __init__(self,name,code,msg):
		self.name = name
		self.code = code
		self.msg = msg

def map_code_errors(basename,errdefs):
	entries = []
	for errcls in errdefs:
		attrs = [s for  s in dir(errcls) if not s.startswith('__') and s!='NAME' and s!='_id' and s!='InnerError' ]
		for attr in attrs:
			obj = getattr(errcls,attr)
			obj = XObject(attr,obj.code,obj.msg)
			entries.append(obj)
	entries =sorted(entries,cmp=lambda x,y: cmp(x.code,y.code))

	if 'java' in lang_def :
		code_writer_java().code_write(basename,entries).content

	if 'objc' in lang_def :
		f = open('%s/%s.h'%(output_path,basename),'w')
		writer = code_writer_objc()
		writer.code_write(basename,entries)
		f.write(writer.content.encode('utf-8'))
		f.close()




def map_code_basetype( basename,basetypes):
	objc_writer = code_writer_objc().code_write_inc_begin(basename)
	for basetype in basetypes:
		attrs = [s for  s in dir( basetype ) if not s.startswith('__') and s!='NAME' and s!='_id' and s!='InnerError' ]
		entries = []

		for attr in attrs:
			value = getattr(basetype,attr)
			obj = XObject(attr,value,'')
			entries.append( obj )

		name = string.split( str(basetype),'.')[-1]

		if 'java' in lang_def :
			code_writer_java().code_write(name,entries)
		objc_writer.code_write(name,entries,False)

	objc_writer.code_write_inc_end(basename)

	if 'objc' in lang_def :
		f = open('%s/%s.h'%(output_path,basename),'w')
		f.write(objc_writer.content)
		f.close()



lang_def = ('objc','java','js')
output_path = '../../common/datatype'
def map():
	map_code_errors( 'SwarmErrors',( desert.errors.ErrorDefs, swarm.error.ErrorDefs,))
	map_code_basetype('SwarmTypes',
					(	swarm.base.AppPlatformType,
						swarm.base.AnalysisTimeGranuleType,
						swarm.base.AnalysisDataModeSubtypeDef
					 )
				)

if __name__ == '__main__':

	if not os.path.exists(output_path): os.mkdir(output_path)
	# if len(sys.argv)>1:
	# 	lang_def = sys.argv[-1]
	map()

