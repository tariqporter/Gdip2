class PointTest extends AhkUnit {
	beforeEach() {
		this.point := new Gdip.Point(100, 200)
	}

	test1() {
		d := this.describe("Gdip.Point")
		d.it("x should be 100").expect(this.point.x == 100).toBeTruthy()
		d.it("y should be 200").expect(this.point.y == 200).toBeTruthy()
	}
}