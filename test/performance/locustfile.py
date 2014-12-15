from locust import HttpLocust, TaskSet, task
import random

class MyTaskSet(TaskSet):
    @task
    def index(self):
      dh = random.randint(1, 1200)
      of = random.choice(["jpg", "gif", "png", "webp"])
      self.client.get("/local/small_light(dh=" + str(dh) + ",da=l,ds=s,cc=FFFFFF,of=" + of + ")/images/example.jpg")

class WebsiteUser(HttpLocust):
    task_set = MyTaskSet
    min_wait=5000
    max_wait=9000
