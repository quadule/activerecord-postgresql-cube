require "spec_helper"

describe Thing do
  subject(:thing) { described_class.new(id: 1, fluffiness: 0.2, crunchiness: 0.5, hotness: 0.3, dryness: 0.7) }

  describe "#similar_by_cube_distance" do
    let(:scope) { thing.similar_by_cube_distance(:features) }

    it "generates the correct SQL" do
      expect(scope.to_sql).to match %r{SELECT "things".*, "things"."features" <-> '\(0.2,0.5,0.3,0.7\)' AS "features_distance" FROM "things" WHERE \(?"things"."id" != 1\)? ORDER BY "features_distance"}
    end
  end
end
