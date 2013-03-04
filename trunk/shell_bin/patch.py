#!/usr/bin/python
#
# patch tool - by claudio@redhat.com
# for EAP 5.1, EPP 5.2
# 
# 2013/02/14 - creation time

# features
# - history of patchs, who, when, where, description
# - versioning

import glob
import os
import zipfile
import json
import shutil
import hashlib
import datetime
import collections
import argparse
import logging
import logging.config
import getpass

logging.config.fileConfig("logging.conf")

def hashfile(afile, blocksize=65536):
    buf = afile.read(blocksize)
    hasher = hashlib.md5()
    while len(buf) > 0:
        hasher.update(buf)
        buf = afile.read(blocksize)
    return hasher.hexdigest()

def parse_date(strdate):
  return datetime.datetime.strptime(strdate, "%Y-%m-%d")

def str_date(dateobj):
  return dateobj.strftime("%Y-%m-%d")

def ask_ok(prompt, retries=4, complaint='Yes or no, please!'):
  while True:
    user_input = raw_input(prompt)
#    print "user input: " + user_input + ", " + repr(user_input)
    if user_input == '': 
      user_input = 'y'
    user_input = user_input.lower()
#    print "user input: " + user_input + ", " + repr(user_input)
    if user_input in ('y', 'ye', 'yes'):
      return True
    if user_input in ('n', 'no', 'nop', 'nope'):
      return False
    retries = retries - 1
    if retries < 0:
      raise IOError('refusenik user')
    logging.info(complaint)

def ignore_not_valid_dir(instance_name):
  _dir = jboss_home + "/jboss-as/server/" + instance_name
  if (not os.path.exists(_dir)):
    logging.info("instance " + _dir + " DOESN'T exists, ignore.")
    return False
  else:
    return True

print ''' 
       This is patch tool to apply updates to a local JBoss server.
       After the patch is applied, any recover to previous state must be manual.
       
      '''
go = raw_input("Continue (Enter) or Cancel (Ctrl+C) ? ")

logging.info("")
logging.info("Date  : " + datetime.datetime.today().isoformat())
logging.info("Who   : " + getpass.getuser())
logging.info("Where : " + os.getcwd())
  
jboss_home = "/opt/jboss-epp-5.2.2"
dir_patches = jboss_home + "/patch_tool/new"
dir_archive = jboss_home + "/patch_tool/archive"
jboss_instances = ['lixo.1', 'lixo.2']


shutil.rmtree("tmp", "true")
os.mkdir("tmp")

def applyPatch(source_file, to_dir, target_file, msg):
  # backup destination file
  # copy new file
  now = datetime.datetime.today().strftime("%Y-%m-%dT%H:%M:%S")
  backupfile = "backup_file_not_recognized"
  target_full_path = to_dir + "/" + target_file
  logging.info(msg)
  target_exists = False;
  for _fi in glob.glob(target_full_path): 
    target_exists = True
    target_full_path = _fi
    backupfile = now + "." + os.path.basename(_fi)
    break

  if (target_exists):
    logging.info("    Backup " + target_full_path + " as " + backupfile)
    shutil.copy2(target_full_path, dir_archive + "/" + backupfile)
    logging.info("    Delete target file " + target_full_path)
    os.remove(target_full_path)
    logging.info("    Copy patch file " + source_file + " to " + to_dir)
    shutil.copy2(source_file, to_dir)
  else:
    logging.info("==> ERROR: Target file \"%s\" doesn't exists",  target_full_path)


parser = argparse.ArgumentParser()
parser.add_argument("-i", help="JBoss distribution directory (the parent of jboss-as). Default: " + jboss_home, default=jboss_home) 
parser.add_argument("-c", help="Confirm all update operations. Values: y,n", choices=['y', 'Y', 'n', 'N'], default='n') 
parser.add_argument("-n", help="Directory where the patches are to be find. Default: " + dir_patches, default=dir_patches) 
parser.add_argument("-a", help="Directory to store all files to be updated. Default: " + dir_archive, default=dir_archive)
parser.add_argument("-p", help="Profiles to be updated. Default: *", default='*') 

_args = parser.parse_args()

jboss_home = _args.i
gconfirm = True if _args.c in ['y', 'Y'] else False
dir_patches = _args.n
dir_archive = _args.a

logging.info("JBoss Home     : " + jboss_home)
logging.info("Backup archive : " + dir_archive)
logging.info("JBoss instances: %s", jboss_instances)
logging.info("")

if _args.p != '*':
  jboss_instances = _args.p.split(',')

if (not os.path.exists(dir_patches)):
  logging.info( "Directory " + dir_patches + " doesn't exists")
  logging.info( "As there is no patch to apply, exit.")
  quit()

if (not os.path.exists(jboss_home)):
  logging.info("JBoss AS " + jboss_home + " directory doesn't exists. Exit.")
  quit()

if (not os.path.exists(dir_archive)):
  logging.info("Directory " + dir_archive + " doesn't exists, but I will create it.")
  os.mkdir(dir_archive)

jboss_instances = filter(ignore_not_valid_dir, jboss_instances)
  
for file in glob.glob(os.path.join(dir_patches, "*.zip")):
  zfile = zipfile.ZipFile(file)
  _fname = os.path.basename(file)
  _tmpDir = os.mkdir(os.path.join("tmp/", _fname))
  zfile.extractall(os.path.join("tmp/", _fname))
  
logging.info("Available patches to apply")
logging.info("")

sortedPatches = {}

for dpatch in os.listdir("tmp"):
  mf = os.path.join("tmp/" + dpatch, "manifest.json")
  jsFile = json.loads(open("tmp/" + dpatch +  "/manifest.json").read())
#  print "date       : " + jsFile['date']
  sortedPatches.update({parse_date(jsFile['date']): dpatch})
dpatch = ''

sortedPatches = collections.OrderedDict(sorted(sortedPatches.items(), key=lambda t: t[0]))

#for item, dirName in sortedPatches.items():
#  print "--> ", str_date(item),  dirName


for item, dirName in sortedPatches.items():
  #mf = os.path.join("tmp/" + dpatch, "manifest.json")
  mf = os.path.join("tmp/" + dirName, "manifest.json")
  jsFile = json.loads(open("tmp/" + dirName +  "/manifest.json").read())
  logging.info( "name       : " + jsFile['name'])
  logging.info("date       : " + jsFile['date'])
  logging.info("file       : " + dirName)
  logging.info("description: " + jsFile['description'])
  for indFile in jsFile['files']:
    logging.info("\tfile : " + indFile['file'] )
    logging.info("\t  to :   " + indFile['target'])
    hexdigest = hashfile(open(os.path.join("tmp/" + dirName, indFile['file'])))
    if hexdigest != indFile['md5']: 
      logging.info("ERROR ==> md5 differs")
      logging.info("\tmd5   : " + indFile['md5'] )
      logging.info("\tnew   : " + hexdigest)
      logging.info("")
      
    autoUp = indFile['auto_update']  
    if (not autoUp):
      logging.info("    ==> This file is marked to perform manual update. Probably, because the jar is contained in a .ear or .war archive.")
      logging.info("")
      continue
    
    apply_patch = False
    if not gconfirm:
      user_input = ask_ok('Update the above file (Y/n) ? ')      
      if (user_input):
        logging.info("==> Manual update ")
        apply_patch = True
      else:
        apply_patch = False
        logging.info("==> DO NOT update")
    else: 
      apply_patch = True
      logging.info("==> automatic update")
        
    if apply_patch: 
      for jb_instance in jboss_instances:
        jbdir = indFile['target'].replace("$JB_HOME$", jboss_home).replace("$JB_PROFILE$", jb_instance)
        applyPatch("tmp/" + dirName + "/" + indFile['file'], jbdir, indFile['target_file'], "Apply patch ")
      
    logging.info("")


  
#shutil.rmtree("tmp", "true")
  
logging.info("=========================================================================================================")

