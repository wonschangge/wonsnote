构建readthedocs
================

asdf
------------

To use Lumache, first install it using pip:

.. code-block:: shell

   git clone --depth 1 https://github.com/wonschangge/wonsnote.git .
   git fetch origin --force --prune --prune-tags --depth 50 refs/heads/main:refs/remotes/origin/main
   git checkout --force origin/main
   git clean -d -f -f
   cat .readthedocs.yaml
   asdf global python 3.10.13
   python -mvirtualenv $READTHEDOCS_VIRTUALENV_PATH
   python -m pip install --upgrade --no-cache-dir pip setuptools
   python -m pip install --upgrade --no-cache-dir sphinx readthedocs-sphinx-ext
   python -m pip install --exists-action=w --no-cache-dir -r docs/requirements.txt
   cat docs/source/conf.py
   python -m sphinx -T -b html -d _build/doctrees -D language=zh_CN . $READTHEDOCS_OUTPUT/html
