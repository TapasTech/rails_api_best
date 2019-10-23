# frozen_string_literal: true

require 'swagger_helper'

describe 'articles API' do
  path '/articles' do
    get '文章列表' do
      tags 'articles'

      consumes 'application/json'

      response 200, 'articles found' do
        examples 'application/json' => {
          data: [
            {
              id: 1,
              title: 'Hello world!',
              summary: 'summary',
              content: 'content'
            },
            {
              id: 2,
              title: 'Hello world!',
              summary: 'summary',
              content: 'content'
            }
          ],
          meta: {
            current_page: 1,
            total_pages: 1,
            next_page: 1,
            total_count: 1,
            per: 1
          }
        }
        schema type: :object,
               properties: {
                 data: { type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             title: { type: :string },
                             summary: { type: :string },
                             content: { type: :string }
                           }
                         } },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer },
                     total_pages: { type: :integer },
                     next_page: { type: :integer },
                     total_count: { type: :integer },
                     per: { type: :integer }
                   }
                 }
               }

        let(:articles) { create_list(:article, 3) }

        before do
          articles
        end

        run_test! do |_response|
          expect_json_sizes(data: 3)
          expect_json_types('data.*', id: :integer, title: :string)
        end
      end
    end

    post '创建文章' do
      tags 'articles'

      consumes 'application/json'

      parameter name: :article, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author: { type: :string },
          summary: { type: :string },
          content: { type: :string }
        },
        required: %w[title content author summary]
      }

      response 200, 'article created' do
        let(:article) { { title: 'foo', content: 'bar', author: 'dave' } }

        run_test! do |_response|
          expect_json_keys('data', %i[id title summary author visit_times created_at])
          expect_json_types('data', author: :string)
          expect_json('data', author: 'dave')
        end
      end

      response 422, 'invalid request' do
        let(:article) { { title: 'foo', content: 'bar' } }

        schema '$ref' => '#/definitions/errors_object'

        run_test! do |_response|
          expect_json(message: "Author can't be blank")
        end
      end
    end
  end

  path '/articles/{id}' do
    get '获取文章详情' do
      tags 'articles'

      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, description: '文章ID'

      response 200, '成功' do
        examples 'application/json' => {
          data: {
            id: 1,
            title: 'Hello world!',
            summary: 'summary',
            content: 'content'
          }
        }
        schema type: :object,
               properties: {
                 data: {
                   id: { type: :integer },
                   title: { type: :string },
                   content: { type: :string }
                 }
               }

        let(:article) { create(:article) }
        let(:id) { article.id }

        run_test! do |_response|
          expect_json('data', author: article.author)
        end
      end

      response 404, '记录没找到' do
        let(:id) { 'invalid' }

        schema '$ref' => '#/definitions/errors_object'

        run_test!
      end
    end
  end
end
