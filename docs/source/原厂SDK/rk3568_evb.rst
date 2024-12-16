rk3568_evb
=============================

RK原厂代码拉取步骤
一,下载rk scripts工具用于生成.git-credentials凭证文件,git clone https://gerrit.rock-chips.com:8443/repo-release/tools/script
二,进入scripts运行./Generate-Credential.x,依次输入:kylinos,lixiang@kylinos.cn或huangshunyu@kylinos.cn,对应emailID配套的私钥文件名(必须置于.ssh下).邮箱目前RK就添加了这俩,注意私钥需和邮箱名对上.
三,编辑.ssh/config文件,针对指定Host添加如下配置(huangshunyu和lixiang分别针对不同的域名及仓库地址):
Host  www.rockchip.com.cn
  HostName www.rockchip.com.cn
  User git
  IdentityFile  /home/chanj/.ssh/rk_id/id_huangshunyu/id_rsa
  IdentitiesOnly  yes
  PubkeyAcceptedKeyTypes  +ssh-rsa
四,初始化repo
repo init --repo-url ssh://git@www.rockchip.com.cn/repo/rk/tools/repo -u ssh://git@www.rockchip.com.cn/linux/rockchip/platform/manifests -b linux -m rk356x_linux_release.xml


repo init --repo-url ssh://git@www.rockchip.com.cn/repo/rk/tools/repo -u ssh://git@www.rockchip.com.cn/standalone/rk/platform/release/manifests -b master -m rk356x.xml

五,同步代码
repo sync -c --no-clone-bundle

报错情况:

1.无法"fork_flow"

chanj@wons:/tmp/1$ repo init --repo-url ssh://git@www.rockchip.com.cn/repo/rk/tools/repo -u ssh://git@www.rockchip.com.cn/linux/rockchip/platform/manifests -b linux -m rk356x_linux_release.xml
Downloading Repo source from ssh://git@www.rockchip.com.cn/repo/rk/tools/repo
remote: Counting objects: 7426, done.
remote: Compressing objects: 100% (2200/2200), done.
remote: Total 7426 (delta 5267), reused 7311 (delta 5152)
repo: warning: verification of repo code has been disabled;
repo will not be able to verify the integrity of itself.

repo: error: unable to resolve "fork_flow"
fatal: cloning the git-repo repository failed, will remove '.repo/repo'

修改repo中的fork_flow为stable,或拉最新的repo.