# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_30_081419) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "account_number"
    t.string "title"
    t.string "increases"
    t.string "description"
    t.string "group"
    t.string "subgroup"
    t.string "statement"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "journal_id", null: false
    t.float "amount"
    t.string "flow"
    t.bigint "account_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_entries_on_account_id"
    t.index ["journal_id"], name: "index_entries_on_journal_id"
  end

  create_table "invoice_journal_links", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "journal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_journal_links_on_invoice_id"
    t.index ["journal_id"], name: "index_invoice_journal_links_on_journal_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "currency", default: "vnd"
    t.date "date_issue"
    t.date "date_due"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.float "total"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "journals", force: :cascade do |t|
    t.datetime "date"
    t.string "description"
    t.string "currency"
    t.string "trans_nat"
    t.boolean "balanced", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "product_id", null: false
    t.string "note"
    t.float "price"
    t.float "factor"
    t.float "amount"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nbr"
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "month_sums", force: :cascade do |t|
    t.datetime "date"
    t.bigint "account_id", null: false
    t.float "amount"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_month_sums_on_account_id"
  end

  create_table "names", force: :cascade do |t|
    t.string "full_name"
    t.string "gender"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "params", force: :cascade do |t|
    t.string "group"
    t.string "value"
    t.string "label"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group"], name: "index_params_on_group"
  end

  create_table "periods", force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.date "date_from"
    t.date "date_to"
    t.float "amount"
    t.string "currency", default: "vnd"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_prices_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "kind"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "style"
  end

  create_table "user_tag_joins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tag_joins_on_tag_id"
    t.index ["user_id"], name: "index_user_tag_joins_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "title"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nationality"
    t.boolean "visible", default: true
  end

  add_foreign_key "entries", "accounts"
  add_foreign_key "entries", "journals"
  add_foreign_key "invoice_journal_links", "invoices"
  add_foreign_key "invoice_journal_links", "journals"
  add_foreign_key "invoices", "users"
  add_foreign_key "line_items", "invoices"
  add_foreign_key "line_items", "products"
  add_foreign_key "month_sums", "accounts"
  add_foreign_key "prices", "products"
  add_foreign_key "user_tag_joins", "tags"
  add_foreign_key "user_tag_joins", "users"
end
