#!/usr/bin/env python

# copy files from itunes album into target directory
# each album in itunes will have it's own directory

from xml.dom.minidom import parse, parseString, Node
import os, time, stat, shutil, sys

def findChildElementsByName(parent, name):
    result = []
    for child in parent.childNodes:
        if child.nodeName == name:
            result.append(child)
    return result

def getElementText(element):
    if element is None: return None
    if len(element.childNodes) == 0: return None
    else: return element.childNodes[0].nodeValue

def getValueElementForKey(parent, keyName):
    for key in findChildElementsByName(parent, "key"):
        if getElementText(key) == keyName:
            sib = key.nextSibling
            while(sib is not None and sib.nodeType != Node.ELEMENT_NODE):
                sib = sib.nextSibling
            return sib

albumDataXml="/Users/Ryan/Pictures/iPhoto Library/AlbumData.xml"
targetDir="/Users/Ryan/Backup/Dropbox"
copyImg=True #set to false to run with out copying files or creating directories
useEvents=True #set to False to use Albums instead of Events

print "Parsing AlbumData.xml"
albumDataDom = parse(albumDataXml)
topElement = albumDataDom.documentElement
topMostDict = topElement.getElementsByTagName('dict')[0]
listOfRollsArray = getValueElementForKey(topMostDict, "List of Rolls")
listOfAlbumsArray = getValueElementForKey(topMostDict, "List of Albums")
masterImageListDict = getValueElementForKey(topMostDict, "Master Image List")

#walk through all the rolls (events) / albums
if useEvents:
    listOfSomethingArray = listOfRollsArray
else:
    listOfSomethingArray = listOfAlbumsArray

for folderDict in findChildElementsByName(listOfSomethingArray, 'dict'):
    if useEvents:
        folderName = getElementText(getValueElementForKey(folderDict, "RollName"))
        print "\n\nProcessing Roll: %s" % (folderName)
    else:
        folderName = getElementText(getValueElementForKey(folderDict, "AlbumName"))
        if folderName == 'Photos':
            continue
        # Uncomment the following 3 lines to only export rolls/albums that start with "Something"
        #if folderName.find('Something') != 0:
            #print "\nSkipping Album: %s" % (folderName)
            #continue
        # Uncomment the following 3 lines to only export rolls/albums that containt with "Something"
        #if folderName.find('Something') == -1:
            #print "\nSkipping Album: %s" % (folderName)
            #continue
        print "\n\nProcessing Album: %s" % (folderName)

    #walk through all the images in this roll/event/album
    imageIdArray = getValueElementForKey(folderDict, "KeyList")
    for imageIdElement in findChildElementsByName(imageIdArray, 'string'):
        imageId = getElementText(imageIdElement)
        imageDict = getValueElementForKey(masterImageListDict, imageId)
        modifiedFilePath = getElementText(getValueElementForKey(imageDict, "ImagePath"))
        originalFilePath = getElementText(getValueElementForKey(imageDict, "OriginalPath"))

        sourceImageFilePath = modifiedFilePath

        modifiedStat = os.stat(sourceImageFilePath)
        basename = os.path.basename(sourceImageFilePath)
        year = str(time.gmtime(modifiedStat[stat.ST_CTIME])[0])
        #targetFileDir = targetDir + "/" + year + "/" + folderName
        targetFileDir = targetDir + "/" + folderName

        if not os.path.exists(targetFileDir):
            print "Directory did not exist - Creating: %s" % targetFileDir
            if copyImg:
                os.makedirs(targetFileDir)

        targetFilePath = targetFileDir + "/" + basename
        iPhotoFileIsNewer = False

        if os.path.exists(targetFilePath):
            targetStat = os.stat(targetFilePath)

            #print "modified: %d %d" % (modifiedStat[stat.ST_MTIME], modifiedStat[stat.ST_SIZE])
            #print "target  : %d %d" % (targetStat[stat.ST_MTIME], targetStat[stat.ST_SIZE])

            #why oh why is modified time not getting copied over exactly the same?
            if abs(targetStat[stat.ST_MTIME] - modifiedStat[stat.ST_MTIME]) > 10 or targetStat[stat.ST_SIZE] != modifiedStat[stat.ST_SIZE]:
                iPhotoFileIsNewer = True
        else:
            iPhotoFileIsNewer = True

        if iPhotoFileIsNewer:
            msg = "copy from:%s to:%s" % (sourceImageFilePath, targetFilePath)
            if copyImg:
                print msg
                shutil.copy2(sourceImageFilePath, targetFilePath)
            else:
                print "test - %s" % (msg)
        else:
            sys.stdout.write(".")
            sys.stdout.flush()

albumDataDom.unlink()

