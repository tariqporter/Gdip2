class SizeTest extends AhkUnit {
	beforeEach() {
		this.size := new Gdip.Size(100, 200)
	}

	test1() {
		d := this.describe("Gdip.Size")
		d.it("Width should be 100").expect(this.size.width == 100).toBeTruthy()
		d.it("Height should be 200").expect(this.size.height == 200).toBeTruthy()
	}
}