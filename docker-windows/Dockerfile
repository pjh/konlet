# Copyright 2017 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO(peterhornyack): switch to 1709 once development is complete.
#FROM microsoft/nanoserver:1709
#FROM microsoft/windowsservercore:1709
FROM microsoft/windowsservercore:latest
MAINTAINER peterhornyack@google.com

# TODO(peterhornyack): where is iptables used?
#RUN apt-get update && apt-get install -y iptables
COPY gce-containers-startup.exe C:\gce-containers-startup.exe

CMD ["C:\gce-containers-startup.exe"]

