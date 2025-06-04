require "rails_helper"

RSpec.describe YearsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/years").to route_to("years#index")
    end

    it "routes to #new" do
      expect(get: "/years/new").to route_to("years#new")
    end

    it "routes to #show" do
      expect(get: "/years/1").to route_to("years#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/years/1/edit").to route_to("years#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/years").to route_to("years#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/years/1").to route_to("years#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/years/1").to route_to("years#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/years/1").to route_to("years#destroy", id: "1")
    end
  end
end
