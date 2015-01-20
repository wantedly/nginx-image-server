require "spec_helper"

describe server(:target) do
  describe http('http://target/images/example.jpg') do
    it "responds OK 200" do
      expect(response.status).to eq(200)
    end
    it "responds as 'image/jpeg'" do
      expect(response.headers['content-type']).to eq("image/jpeg")
    end
  end

  describe http('http://target/local/small_light(dh=600,da=l,ds=s,of=png)/images/example.jpg') do
    it "responds OK 200" do
      expect(response.status).to eq(200)
    end
    it "responds as 'image/png'" do
      expect(response.headers['content-type']).to eq("image/png")
    end
  end

  describe http('http://target/local/small_light(dh=600,da=l,ds=s,of=webp)/images/example.jpg') do
    it "responds OK 200" do
      expect(response.status).to eq(200)
    end
    it "responds as 'image/webp'" do
      expect(response.headers['content-type']).to eq("image/webp")
    end
  end

  describe http('http://target:8090/status') do
    it "responds OK 200" do
      expect(response.status).to eq(200)
    end
    it "responds content including 'Active connections'" do
      expect(response.body).to include("Active connections")
    end
  end

  describe http('http://target/local/small_light(dh=3600,da=l,ds=s,of=webp)/images/example.jpg') do
    it "responds Bad Request 400" do
      expect(response.status).to eq(400)
    end
  end

  describe http('http://target/local/small_light(ch=3600,da=l,ds=s,of=webp)/images/example.jpg') do
    it "responds Bad Request 400" do
      expect(response.status).to eq(400)
    end
  end

  describe http('http://target/local/small_light(dw=3600,da=l,ds=s,of=webp)/images/example.jpg') do
    it "responds Bad Request 400" do
      expect(response.status).to eq(400)
    end
  end

  describe http('http://target/local/small_light(cw=3600,da=l,ds=s,of=webp)/images/example.jpg') do
    it "responds Bad Request 400" do
      expect(response.status).to eq(400)
    end
  end
end
