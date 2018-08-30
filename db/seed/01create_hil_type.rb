class CreateHilTypes
  def self.create_database
    codes = %w[DS LC X NI]
    descriptions = %w[dSpace LabCar CarMakerXeno NationalInstruments]

    ActiveRecord::Base.transaction do
      HilType.create(code: "UN", description: "UnKnown")
      codes.zip(descriptions).each do  |code, description|
          HilType.create(code: code, description: description)
      end
    end
  end
end

CreateHilTypes.create_database
