require 'datastorage'
require 'tenderstoragecontroller'

describe TenderStorageController do
  FILENAME = 'data/test_data.json'.freeze
  before(:all) do
    File.open(FILENAME, 'w+')
  end
  after(:all) do
    File.delete(FILENAME)
  end
  let(:storage) do
    DataStorage.new(FILENAME)
  end
  let(:tender) do
    Tender.new(1, ShipmentTenderData.new('Export', 'Wood tender',
                                         Route.new('Vilnius', 'Kaunas'),
                                         Date.today))
  end
  let(:updated_tender) do
    Tender.new(1, ShipmentTenderData.new('Import', 'Wood tender',
                                         Route.new('Vilnius', 'Kaunas'),
                                         Date.today))
  end
  context 'when empty storage is passed' do
    it 'returns none tenders' do
      tender_storage_controller = described_class.new(storage)
      tenders = tender_storage_controller.tenders
      expect(tenders.length).to eq(0)
    end
  end

  context 'when new tender is added' do
    it 'stores it' do
      tender_storage_controller = described_class.new(storage)
      tender_storage_controller.add_new(tender)
      tenders = tender_storage_controller.tenders
      expect(tenders.length).to eq(1)
    end
  end
  context 'when modified tender is passed' do
    it 'updates deletes previous one and returns new one' do
      tender_storage_controller = described_class.new(storage)
      tender_storage_controller.add_new(tender)
      tender_storage_controller.update(updated_tender)
      tenders = tender_storage_controller.tenders
      expect(tenders[0]).to eq(updated_tender)
    end
  end
  it 'removes tender by id' do
    tender_storage_controller = described_class.new(storage)
    tender_storage_controller.add_new(tender)
    tender_storage_controller.remove_by_id(1)
    tenders = tender_storage_controller.tenders
    expect(tenders.length).to eq(0)
  end
end