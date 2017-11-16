runPipeline('githubflow') {
  appName = 'jenkins'
  platform = 'chef'
  role = ['jenkins-master', 'jenkins-slave']
  cookbookName = 'chef_test_3'
  autodeployToEnvironments = 'integration, qa, staging'
}
