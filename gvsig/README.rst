Creating workspace
==================

This script creates a gvSIG workspace with the last available build and the
basic projects. The workspace will be created as a git repo in
/tmp/workspace-from-scratch having:

- master branch: the projects in their last available version
- a *remote* pointing to the proper git mirror for every component:
  https://gitorious.org/gvsig-desktop/
- a *branch* tracking every remote with **all** its history!

You will only need git as a dependence.

What I'm likely work on next
============================

Likely the script will become something as ::

       ./create-workspace.sh
           --path={dir where create the workspace}
           --version={which version you want: gvSIG 1.11, build 1411, ...}
           --components={which components you want to install: all, core, ...}

ToDo
====

Document:

- How should I update to last changes?
- How do I maintain local patches to gvSIG code?
- How can I send the patches upstream?
