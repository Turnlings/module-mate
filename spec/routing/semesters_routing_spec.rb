require "rails_helper"

RSpec.describe SemestersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/semesters").to route_to("semesters#index")
    end

    it "routes to #new" do
      expect(get: "/semesters/new").to route_to("semesters#new")
    end

    it "routes to #show" do
      expect(get: "/semesters/1").to route_to("semesters#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/semesters/1/edit").to route_to("semesters#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/semesters").to route_to("semesters#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/semesters/1").to route_to("semesters#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/semesters/1").to route_to("semesters#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/semesters/1").to route_to("semesters#destroy", id: "1")
    end
  end
end
