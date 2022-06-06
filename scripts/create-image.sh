#!/bin/bash

curl 'https://console.redhat.com/api/edge/v1/images' \
  -H 'authority: console.redhat.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H "Authorization: Bearer $ACTIVE_TOKEN" \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'origin: https://console.redhat.com' \
  -H 'referer: https://console.redhat.com/beta/edge/manage-images?create_image=true' \
  --data-raw '{"name":"testing-one-two","version":0,"description":"sample description","distribution":"rhel-85","imageType":"rhel-edge-installer","packages":[{"name":"curl"},{"name":"net-tools"},{"name":"podman"},{"name":"wget"}],"outputTypes":["rhel-edge-installer","rhel-edge-commit"],"commit":{"arch":"x86_64"},"installer":{"username":"tosin","sshkey":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzDoM4Pg/80xxgeEAoPdZZDrAEbbB3Fueo+BVAoBpPYhBt4+cR9mIe6KFqFBH/BUOoQ6kMBxjTILX18tVlw0VGS/BYx0oRoR+Tji1DK+EN0nthM8QgDXJy2UNGfZpkM5Wo6z2qWo96fvzaTI2MZ7QmEnb61yA5ZsyAwux1w5zSLO+O9l+ftL8jglwI1YG2ukoNxX5sHmm1zGkKhFshSSi00azzu1dCxGDUBI8IjVyMbRRsXat/eKZc1zH1pbMJzqh8RjCzG6j9xcfhSP/R9cD1H82JswGNnZu26VyZprUG5Qu7GhL4AU2U59oluJsx5lNWDxQvWmQpfY0PobO0OWTKezfiZCkNYH6Rt19UODjm2beGqJT5lQ9m8D4envmTUIj+fUUQjT6KCw5ONTUvXaate5F4uT7BnwXENOhZhaOFgIOGcBpNV0jfMkjHqlLBFO4sTlEc2pfZa3OPrxiqAwFfJsE1OSAJkP09t9M73fMfsUlAfV2csfOziOIUldf9/p0okJ9Rkptl9oU+CQeyKmHj8tRQmDOEG2KMrAo9Iey0TYnxhomV3kRqEiOeOk0LiR0DT6WcTQLiloH4ipIiG+DKc3ZOXYIqEUfCz33kaa8zbMjBECeXatshjofpF3I/CZl+k+F0KNmaFM4nxfextNr3/oVmXPa5n7OgvnM4uYObaQ== takinosh@redhat.com\n"}}' \
  --compressed ;
