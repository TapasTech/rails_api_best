require 'rails_helper'

RSpec.describe ArticlesController, type: :request do
  let(:article) { create(:article) }
  let(:articles) { create_list(:article, 3) }

  describe "GET #index" do
    it "returns http success" do
      articles

      get articles_path

      expect(response).to have_http_status(:success)
      expect_json_sizes(data: 3)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get article_path(article.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      delete article_path(article.id)

      expect(response).to have_http_status(:no_content)
    end
  end

end
