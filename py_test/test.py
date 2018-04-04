import requests
import sys
import json

#CREATE PROJECT
print("Creating 1 project")
filepath = 'new_project.json'
with open(filepath) as fh:
    mydata = fh.read()
    response = requests.post('http://localhost:3000/replan/projects/',
                data=mydata,                         
                headers={'content-type':'application/json'})
    project = json.loads(response.text)
print(response.status_code, response.reason)
print(response.text)
print("Created project with id " + str(project["id"]) + "\n")

project_id = str(project["id"])

#CREATE FEATURES
print("Creating features")
filepath = 'new_feature_1.json'
with open(filepath) as fh:
    mydata = json.loads(fh.read())
    features = []
    for x in range (0,len(mydata)):
        response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/features/create_one',
					data=json.dumps(mydata[x]),
					headers={'content-type':'application/json'})
        feature = json.loads(response.text)
        print(response.status_code, response.reason)
        print(response.text)
        features.append(feature)

s = "Created features with ids: "
for x in range (0,len(mydata)):
	s += str(features[x]["id"]) + ","
print(s)
print("\n")

#DEPENDENCIES
print("Add dependencies to features")
print("Set feature " + str(features[1]["id"]) + " as a dependency of " + str(features[0]["id"]))
response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/features/' + str(features[0]["id"]) + '/dependencies',
					data='[{"feature_id":' + str(features[1]["id"]) + '}]',
					headers={'content-type':'application/json'})
print(response.status_code, response.reason)
print(response.text)
print("Set feature " + str(features[2]["id"]) + " as a dependency of " + str(features[1]["id"]))
response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/features/' + str(features[1]["id"]) + '/dependencies',
					data='[{"feature_id": ' + str(features[2]["id"]) + '}]',
					headers={'content-type':'application/json'})
print(response.status_code, response.reason)
print(response.text)
print("Set feature " + str(features[5]["id"]) + " as a dependency of " + str(features[4]["id"]))
response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/features/' + str(features[4]["id"]) + '/dependencies',
					data='[{"feature_id": ' + str(features[5]["id"]) + '}]',
					headers={'content-type':'application/json'})
print(response.status_code, response.reason)
print(response.text)

print("\n")

#SKILLS
print("Creating skills")
filepath = 'new_skills.json'
with open(filepath) as fh:
    mydata = json.loads(fh.read())
    skills = []
    for x in range (0,len(mydata)):
        response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/skills',
					data=json.dumps(mydata[x]),
					headers={'content-type':'application/json'})
        feature = json.loads(response.text)
        print(response.status_code, response.reason)
        print(response.text)
        skills.append(feature)

s = "Created skills with ids: "
for x in range (0,len(mydata)):
	s += str(skills[x]["id"]) + ","
print(s)
print("\n")

#RESOURCES
print("Creating resourcess")
filepath = 'new_resources.json'
with open(filepath) as fh:
    mydata = json.loads(fh.read())
    resources = []
    for x in range (0,len(mydata)):
        response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/resources',
					data=json.dumps(mydata[x]),
					headers={'content-type':'application/json'})
        feature = json.loads(response.text)
        print(response.status_code, response.reason)
        print(response.text)
        resources.append(feature)

s = "Created resources with ids: "
for x in range (0,len(mydata)):
	s += str(resources[x]["id"]) + ","
print(s)
print("\n")

#DAYSLOTS
print("Creating dayslots")
filepath = 'new_dayslots.json'
with open(filepath) as fh:
    mydata = json.loads(fh.read())
    dayslots = []
    for x in range (0,len(mydata)):
        response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/dayslots',
					data=json.dumps(mydata[x]),
					headers={'content-type':'application/json'})
        feature = json.loads(response.text)
        print(response.status_code, response.reason)
        print(response.text)
        dayslots.append(feature)

s = "Created dayslots with ids: "
for x in range (0,len(mydata)):
	s += str(dayslots[x]["id"]) + ","
print(s)
print("\n")

#ASSIGN SKILLS TO RESOURCES
print("Assigning skills to resources")
for x in range(0,len(resources)):
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/resources/' + str(resources[x]["id"]) + '/skills',
					data='[{"skill_id":' + str(skills[0]["id"]) + '}]',
					headers={'content-type':'application/json'})
    print(response.status_code, response.reason)
    print(response.text)
for x in range(0,len(resources)-1):
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/resources/' + str(resources[x]["id"]) + '/skills',
					data='[{"skill_id":' + str(skills[1]["id"]) + '}]',
					headers={'content-type':'application/json'})
    print(response.status_code, response.reason)
    print(response.text)
for x in range(0,len(resources)-2):
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/resources/' + str(resources[x]["id"]) + '/skills',
					data='[{"skill_id":' + str(skills[2]["id"]) + '}]',
					headers={'content-type':'application/json'})
    print(response.status_code, response.reason)
    print(response.text)

print("\n")

#ASSIGN SKILLS TO FEATURES
print("Assigning skills to features")
for x in range(0,len(features)):
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/features/' + str(features[x]["id"]) + '/skills',
					data='[{"skill_id":' + str(skills[x%3]["id"]) + '}]',
					headers={'content-type':'application/json'})
    print(response.status_code, response.reason)
    print(response.text)
print("\n")

#ASSIGN DAYSLOTS TO RESOURCES
print("Assign dayslots to resources")
for x in range(0,len(resources)):
    for y in range(0,len(dayslots)):
        response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/resources/' + str(resources[x]["id"]) + '/dayslots',
					data='[{"id":' + str(dayslots[y]["id"]) + '}]',
					headers={'content-type':'application/json'})
        print(response.status_code, response.reason)
        print(response.text)
print("\n")


print("Created a project with " + str(len(features)) + " features, " + str(len(resources)) + " resources")

#CREATE PROJECT
print("Creating release")
filepath = 'new_release.json'
with open(filepath) as fh:
    mydata = fh.read()
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/releases/',
                data=mydata,                         
                headers={'content-type':'application/json'})
    release = json.loads(response.text)
print(response.status_code, response.reason)
print(response.text)
print("Created release with id " + str(release["id"]) + "\n")

release_id = str(release["id"])


#ASSIGN RESOURCES TO RELEASE
print("Assign resources to release")
for x in range(0,len(resources)):
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/releases/' + release_id + '/resources',
					data='[{"resource_id":' + str(resources[x]["id"]) + '}]',
					headers={'content-type':'application/json'})
    print(response.status_code, response.reason)
    print(response.text)
print("\n")

#ASSIGN FEATURES
print("Assign features to release")
for x in range(0,len(features)):
    response = requests.post('http://localhost:3000/replan/projects/' + project_id + '/releases/' + release_id + '/features',
					data='[{"feature_id":' + str(features[x]["id"]) + '}]',
					headers={'content-type':'application/json'})
    print(response.status_code, response.reason)
    print(response.text)
print("\n")
