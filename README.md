# Welcome to ValidateThis

**A Validation Framework for ColdFusion Objects**

ValidateThis is a framework that allows you to define validation rules for your ColdFusion objects (or simple structs) in a single place (either an XML file, a JSON file or in ColdFusion code) and will then generate client-side and server-side validations for you.

## Getting Started

1. [Download](http://validatethis.riaforge.org/index.cfm?event=action.download) the ValidateThis current stable release, which includes the framework and all demo code.
2. Check out the [ValidateThis Quick-Start Guide](https://web.archive.org/web/20141007151527/http://www.validatethis.org/docs/wiki/QuickStart_Guide.cfm) (archived on web.archive.org)
3. Refer to the following useful resources.

### Resources

* [Documentation](https://web.archive.org/web/20141011160101/http://www.validatethis.org/docs/) (archived on web.archive.org)
* [API Documentation](http://www.validatethis.org/docs/api/) (JavaDoc style)
* ~~[Live Demo](https://web.archive.org/web/20141007151527/http://validatethis.org/validatethis/samples/FacadeDemo/index.cfm)~~ (archived; broken)
* [Bob Silverberg's ValidateThis blog posts](http://www.silverwareconsulting.com/index.cfm/ValidateThis)
* [Questions and Discussion](http://groups.google.com/group/validatethis)
* [ValidateThis.org Project Home Page](https://web.archive.org/web/20141007151527/http://www.validatethis.org/)

## Contributing

You are encouraged to contribute to ValidateThis, and there are a variety of ways to help:

* Discuss ideas and help answer questions on the [ValidateThis discussion list](http://groups.google.com/group/validatethis)
* Report bugs or feature requests to the [issue tracker](https://github.com/ValidateThis/ValidateThis/issues)
* ~~Help improve the [documentation](https://web.archive.org/web/20141007151527/http://www.validatethis.org/docs/)~~ (wiki is dead)
* Help test new features and releases
* Contribute to the discussion on developing the framework on the [ValidateThis development list](http://groups.google.com/group/validatethis-dev)
* Submit bug fixes or help code new features (see _Code Contributions and Git Workflow_, below)

### Code Contributions

The [ValidateThis development list](http://groups.google.com/group/validatethis-dev) is a good place to ask questions or discuss large changes before coding. Please also review the following sections concerning Git configuration to deal with line endings and the Git workflow model used by this project.

#### Dealing with Line Endings

As recommended by [this GitHub Help page](http://help.github.com/dealing-with-lineendings/), we ask that all ValidateThis developers set their Git `core.autocrlf` setting accordingly.

**Linux and Mac OS X:**

	git config --global core.autocrlf input

**Windows:**

	git config --global core.autocrlf true

If you do not want to set `core.autocrlf` globally, you can set it as a repository option by changing to your ValidateThis clone directory and running one of the above commands without the `--global` option. For example:

	cd ~/Projects/ValidateThis
	git config core.autocrlf input

#### Git Workflow

The git repo's _develop_ branch is used as the primary development branch. The _master_ branch will always be the current stable release. When finalizing a release, a release branch will be used (e.g., _release-0.99_). The Git workflow employed for ValidateThis development is nicely detailed in this blog series, by Bob Silverberg, [A Git Workflow for Open Source Collaboration](http://www.silverwareconsulting.com/index.cfm/Git-Workflow):

* [Part I - Introduction](http://www.silverwareconsulting.com/index.cfm/2010/9/13/A-Git-Workflow-for-Open-Source-Collaboration--Part-I--Introduction)
* [Part II - Getting Started](http://www.silverwareconsulting.com/index.cfm/2010/9/15/A-Git-Workflow-for-Open-Source-Collaboration--Part-II--Getting-Started)
* [Part III - Developing Code](http://www.silverwareconsulting.com/index.cfm/2010/9/17/A-Git-Workflow-for-Open-Source-Collaboration--Part-III--Developing-Code)
* [Part IV - Submitting Contributions](http://www.silverwareconsulting.com/index.cfm/2010/9/20/A-Git-Workflow-for-Open-Source-Collaboration--Part-IV--Submitting-Contributions)

Here's a very brief look at the git commands used for an example code contribution:

	# Fork [ValidateThis](https://github.com/ValidateThis/ValidateThis) (if not already done).

	# Clone your fork (if not already done):
	git clone git@github.com:myGitHubAccount/ValidateThis.git

	# Add main repo as "upstream" remote:
	git remote add upstream git://github.com/ValidateThis/ValidateThis.git

	# Create/checkout a local feature branch:
	git checkout -b myFeatureBranch develop

	# Hack, commit, squash (if needed), etc.

	# Rebase on upstream "develop" branch before merging:
	git pull --rebase upstream develop

	# Merge your change and push to your fork:
	git checkout develop
	git merge --no-ff myFeatureBranch
	git push origin develop

	# Delete your feature branch:
	git branch -d myFeatureBranch

	# Send pull request.

## License

ValidateThis is released under the [Apache License, Version 2](http://www.apache.org/licenses/LICENSE-2.0).

