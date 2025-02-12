//
//  ClinicDoctorsView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit


class ClinicDoctorsView: UIView {
    
    // MARK: - Properties
    @IBOutlet weak var doctorsCollectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    var doctorsPublisher: AnyPublisher<[ClinicDoctor], Never>?
    var doctors : [ClinicDoctor]?
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupView()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupView()
        setupCollectionView()
    }
    private func commonInit(){
        self.addXibSubview(named: ClinicProfileViews.clinicDoctorsView.rawValue)
        bindData()
    }
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        // Add your UI setup here
    }
    
    // MARK: - Data Binding
    func bindData() {
        doctorsPublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctors in
                self?.doctors = doctors
                self?.doctorsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    

}
extension ClinicDoctorsView:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        doctorsCollectionView.delegate = self
        doctorsCollectionView.dataSource = self
        doctorsCollectionView.registerCell(cellClass: DoctorSearchCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doctors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorSearchCollectionViewCell", for: indexPath) as? DoctorSearchCollectionViewCell else {
            fatalError("Unable to dequeue DoctorSearchCollectionViewCell")
        }
        
        let doctor = doctors?[safe: indexPath.row]
        cell.doctorName.text = doctor?.name ?? "Unknown Doctor"
        cell.AdressLabel.text = doctor?.address ?? "Address not available"
        cell.feesLabel.text = doctor?.price ?? "Fees not available"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 241)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let doctor = doctors?[safe: indexPath.row] else { return }
//        coordinator.navToDoctorProfile(doctorID: String(doctor.id))
    }
}
