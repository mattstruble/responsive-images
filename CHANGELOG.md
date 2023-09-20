# CHANGELOG



## v0.1.3 (2023-09-20)

### Fix

* fix(docker): remove release dependencies now that it&#39;s on tag pushes ([`3e051b5`](https://github.com/mattstruble/responsive-images/commit/3e051b53925d209073acc7f8df98f6c1ee15df92))


## v0.1.2 (2023-09-20)

### Fix

* fix(docker): releases to use semver version of tags

Signed-off-by: Matt Struble &lt;mattstruble@outlook.com&gt; ([`bbe9540`](https://github.com/mattstruble/responsive-images/commit/bbe95406060e7ba496f375046b16107591f65c4c))


## v0.1.1 (2023-09-19)

### Ci

* ci: give write permissions to packages

Signed-off-by: Matt Struble &lt;mattstruble@outlook.com&gt; ([`04d4ad5`](https://github.com/mattstruble/responsive-images/commit/04d4ad505e2d4577843a2d58adf30eb4152afd71))

### Fix

* fix: semantic-release picking up the license template ([`c061ffe`](https://github.com/mattstruble/responsive-images/commit/c061ffe329c4ae3f671f11164d7a5920eecbc4c3))

### Style

* style: resolve lint errors ([`dd86ea4`](https://github.com/mattstruble/responsive-images/commit/dd86ea46559a7503de4a22ff068b02a49a4f707e))


## v0.1.0 (2023-09-19)

### Chore

* chore: resolve dockerfile lint ([`d807823`](https://github.com/mattstruble/responsive-images/commit/d807823af9a692f7d502a90a6e3565c4165b1d0e))

* chore: fix python linting errors ([`2e0145c`](https://github.com/mattstruble/responsive-images/commit/2e0145cc270b83db5ab5b9360aeb2e3bdbdf7b7c))

* chore: fix linting errors ([`5865ba5`](https://github.com/mattstruble/responsive-images/commit/5865ba52e43e7607c24cc7c4b2c9c7824e27e2de))

* chore: adding skjold config ([`7e90a2d`](https://github.com/mattstruble/responsive-images/commit/7e90a2daa9c388577f059f53a01f3884e007958e))

* chore(pyproject): update linting rules in pyproject toml ([`fe05c08`](https://github.com/mattstruble/responsive-images/commit/fe05c08d28a268ddb7df7e14ee6f13f19f01e7be))

### Ci

* ci: automatic versioning and deployment ([`a34aa56`](https://github.com/mattstruble/responsive-images/commit/a34aa565bfd6377747213b2525b1967223e285f5))

* ci: improve python workflow ([`d749081`](https://github.com/mattstruble/responsive-images/commit/d749081113db55bb5c201bd33d963e5681252b79))

* ci: update pre-commit hooks and makefile scripts ([`7d5d927`](https://github.com/mattstruble/responsive-images/commit/7d5d9270fa561ce2793dce232338b9c8ede6b5d0))

* ci: added pre-commit hooks ([`7c1ebf5`](https://github.com/mattstruble/responsive-images/commit/7c1ebf5ed3fc9112f999ff875f67bd1a019b87d7))

### Documentation

* docs: add repository badges ([`5a69a03`](https://github.com/mattstruble/responsive-images/commit/5a69a03c5e5bc02de1cf8d5d2953f17489538cea))

* docs: clear out template readme ([`29135b7`](https://github.com/mattstruble/responsive-images/commit/29135b774b5ad1e4f00b556f0e9ab983a3917f09))

### Feature

* feat(docker): create slim docker container for app ([`9654169`](https://github.com/mattstruble/responsive-images/commit/9654169264047c463d998ca4251aad80277c8524))

### Fix

* fix(dockerfile): shrink image and remove mounting /app dir in runtime

Excluded poetry from final environment and cleaned up caches after each
step.

Github actions will automatically mount the working dir, which would
overwrite anything previously mounted. So by keeping /app unmounted we
can still reference and run the application code.

Signed-off-by: Matt Struble &lt;mattstruble@outlook.com&gt; ([`8ff2c96`](https://github.com/mattstruble/responsive-images/commit/8ff2c964004132ed6df2deb32312b306ca208a74))

### Unknown

* Update codacy.yml ([`c66cd7a`](https://github.com/mattstruble/responsive-images/commit/c66cd7a9b87ec80466dbe7deae5b32e3fd57c16a))

* Create codacy.yml ([`f3db128`](https://github.com/mattstruble/responsive-images/commit/f3db1280cd10500bdc85de6760d8761c3177c558))

* update license to gpl3 ([`794e5ed`](https://github.com/mattstruble/responsive-images/commit/794e5ede391f29de47033bc4a6634dcbc84835f8))

* Initial commit ([`095732a`](https://github.com/mattstruble/responsive-images/commit/095732a36704ef5d4901b0c2388a7eea0e125021))
