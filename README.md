# zinit-annex-readurl<a name="zinit-annex-readurl"></a>

<!-- mdformat-toc start --slug=github --maxlevel=6 --minlevel=2 -->

- [Usage](#usage)
- [Skipping `dlink''` Ice](#skipping-dlink-ice)
- [Sorting matched URLs/versions](#sorting-matched-urlsversions)
- [Filtering The Matched URLs](#filtering-the-matched-urls)
- [Examples](#examples)

<!-- mdformat-toc end -->

## Usage<a name="usage"></a>

Load as a regular plugin via:

```zsh
zinit light zdharma-continuum/z-a-readurl
```

After executing the above command (possibly via `zshrc`), it's then possible to use the `dlink''`
and `dlink0''` ices and the special `as'readurl|…'` value of the `as''` ice.

This Zinit extension allows to automatically download the newest version of a file to which the URL
is hosted on a webpage.

The annex provides:

1. Two new ices: `dlink''` and `dlink0''`.
2. A handling of the special values of the `as''` ice, i.e.: of `as'readurl'`,
   `as'readurl|command'`, etc.

> **Note**: The annex works only with snippets, not plugins.

It works as follows:

- invoke `snippet` (or pass the `http://…` address using the `for` syntax) on the web-page that
  hosts the URL to the file to download,
- provide `dlink''` ice with the expected file-download URL, replacing the version with the
  `%VERSION%` keyword,
- also, provide `as''` ice with one of the following values: `readurl`, `readurl|command`,
  `readurl|completion`, `readurl|null`; the part after the `|` has the same meaning as in the normal
  `as''` ice.

So, for example:

````zsh
zinit for \
    as'readurl|command' \
    dlink'/junegunn/fzf-bin/releases/download/%VERSION%/fzf-%VERSION%-linux_amd64.tgz'
    extract \
    id-as'fzf'
  https://github.com/junegunn/fzf-bin/releases/
```
The snippet is just an example. The same effect is obtained by loading as `junegunn/fzf-bin` plugin
with `from'gh-r'` ice.

As demonstrated, the `dlink''` can be a relative or an absolute path and also a full URL (i.e.:
beginning with the `http://…` prefix).

## Intermediate Download Page

Sometimes, like in the case of the [terraform](http://releases.hashicorp.com/terraform) command, the download link isn't on the download page but on a page listed on it. In such cases utilize
the `dlink0''` ice and provide the pattern for the additional, intermediate download page. For
For example, in the case of `terraform`, the Zinit command is:

```zsh
zinit for \
    as'readurl|command' \
    dlink0'/terraform/%VERSION%/' \
    dlink'/terraform/%VERSION%/terraform_%VERSION%_linux_386.zip' \
    extract \
    id-as'terraform' \
  http://releases.hashicorp.com/terraform/
````

## Skipping `dlink''` Ice<a name="skipping-dlink-ice"></a>

Sometimes the URL of the download page differs from the URL of the archive in just a few
`/`-sections. In such a case, it is possible to skip the `dlink''` ice by appending a `++`-separated
fragment of the archive URL, like so:

```zsh
zinit for \
    as'readurl|command' \
    extract \
  http://domain.com/download-page++/archive.zip
```

If the archive URL has some different `/`-sections, then it's possible to strip the conflicting ones
from the download URL by using `+++`, `++++`, etc. – the number of the `/`-section that'll be
stripped equals the number of the `+` minus 2. So, for example:

```zsh
zinit for \
    as'readurl|command' \
    extract \
  http://domain.com/download-page/removed-section+++/archive.zip
```

## Sorting matched URLs/versions<a name="sorting-matched-urlsversions"></a>

Sometimes the download page doesn't list the package versions from newest to the oldest, but in some
other order. In such case, it's possible to sort the URLs / package versions by prepending the
chosen `dlink` ice (`dlink0''` or `dlink''`) with the exclamation mark (`dlink'!…'`, etc.). See the
next section for an example:

## Filtering The Matched URLs<a name="filtering-the-matched-urls"></a>

Sometimes some unwanted URLs match the `dlink''`/`dlink0''` regex/pattern. In such case it's
possible to filter them out by appending a filtering regex to the `dlink''` ice as:
`dlink='the-main-regex~%the-unwanted-URLs-regex%'` (or the same for `dlink0''`). An example package
that can benefit from this is the [Open Shift](https://www.openshift.com/) client, which doesn't
sort the URLs from latest to the oldest – hence the exclamation mark (`!`) prepend – and it has
special URLs like `stable-4.4` or `candidate-4.5` together with the regular version URLs (like
`4.5.0-rc.1`):

```zsh
zinit for \
    as'readurl|command' \
    dlink'openshift-client-windows-%VERSION%.zip' \
    dlink0'!%VERSION%~%(stable|latest|fast|candidate).*%' \
    id-as'ocp' \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/
```

The above snippet of Zsh code / Zinit invocation will sort the URLs (`dlink0'!…'`) and then filter
out the special ones from the results (via `…~%(stable|latest|fast|candidate).*%`), this way
selecting the latest version of the Open Shift client.

## Examples<a name="examples"></a>

[**Pulumi**](https://www.pulumi.com/), a tool to create, deploy, and manage modern cloud software.

```zsh
zi for \
    as'readurl|null' \
    dlink'https://get.pulumi.com/releases/sdk/pulumi-%VERSION%-linux-x64.tar.gz' \
    extract'!' \
    id-as'pulumi' \
    sbin'pulumi*' \
  https://www.pulumi.com/docs/get-started/install/versions/
```
