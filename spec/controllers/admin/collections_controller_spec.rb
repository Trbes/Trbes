require "rails_helper"

describe Admin::CollectionsController do
  let(:collection) { create(:collection) }
  let!(:collections) { [collection] }

  before do
    stub_auth
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.code).to eq("200")
    end

    it "assigns collections" do
      expect(controller.collections).to match_array(collections)
    end

    it "renders 'index' template" do
      expect(controller).to render_template(:index)
    end
  end

  describe "GET #show" do
    before do
      get :show, id: collection.id
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.code).to eq("200")
    end

    it "assigns collection" do
      expect(controller.collection).to eq(collection)
    end

    it "renders 'show' template" do
      expect(controller).to render_template(:show)
    end
  end

  describe "GET #new" do
    before do
      get :new
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.code).to eq("200")
    end

    it "assigns collection" do
      expect(controller.collection).to be_a(Collection)
      expect(controller.collection.new_record?).to be true
    end

    it "renders 'new' template" do
      expect(controller).to render_template(:new)
    end
  end

  describe "GET #edit" do
    let!(:collection) { create(:collection) }

    before do
      get :edit, id: collection.id
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.code).to eq("200")
    end

    it "assigns collection" do
      expect(controller.collection).to eq(collection)
    end

    it "renders 'edit' template" do
      expect(controller).to render_template(:edit)
    end
  end

  describe "POST #create" do
    before do
      post :create, collection: collection_attributes
    end

    context "with valid attributes" do
      let(:collection_attributes) { attributes_for(:collection) }

      it "assigns collection" do
        expect(controller.collection).to be_a(Collection)
        expect(controller.collection.new_record?).to be true
      end

      it "redirects to collection" do
        expect(controller).to redirect_to([:admin, Collection.last])
      end
    end

    context "with invalid attributes" do
      let(:collection_attributes) { attributes_for(:collection).slice!(:name) }

      it "renders 'new' template" do
        expect(controller).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    let!(:collection) { create(:collection) }

    before do
      patch :update, id: collection.id, collection: collection_attributes
    end

    context "with valid attributes" do
      let(:collection_attributes) { attributes_for(:collection) }

      it "assigns collection" do
        expect(controller.collection).to eq(collection)
      end

      it "redirects to collection" do
        expect(controller).to redirect_to([:admin, collection])
      end
    end

    context "with invalid attributes" do
      let(:collection_attributes) { attributes_for(:collection).merge(name: "") }

      it "renders 'edit' template" do
        expect(controller).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:collection) { create(:collection) }

    before do
      delete :destroy, id: collection.id
    end

    it "renders 'index' template" do
      expect(controller).to render_template(:index)
    end
  end
end
