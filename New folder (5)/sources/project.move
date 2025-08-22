module MyModule::ClinicalTrialTransparency {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::string::{Self, String};
    
    /// Struct representing a clinical trial with results.
    struct ClinicalTrial has store, key {
        trial_id: String,        // Unique identifier for the trial
        results_hash: String,    // Hash of the trial results data
        publication_time: u64,   // Timestamp when results were published
        is_published: bool,      // Whether results have been made public
    }
    
    /// Error codes
    const E_TRIAL_EXISTS: u64 = 1;
    const E_ALREADY_PUBLISHED: u64 = 2;
    const E_TRIAL_NOT_EXISTS: u64 = 3;
    
    /// Function to register a new clinical trial.
    public fun register_trial(
        researcher: &signer, 
        trial_id: String
    ) {
        let trial = ClinicalTrial {
            trial_id,
            results_hash: string::utf8(b""),
            publication_time: 0,
            is_published: false,
        };
        move_to(researcher, trial);
    }
    
    /// Function to publish trial results with immutable hash.
    public fun publish_results(
        researcher: &signer, 
        trial_owner: address, 
        results_hash: String
    ) acquires ClinicalTrial {
        let trial = borrow_global_mut<ClinicalTrial>(trial_owner);
        
        // Ensure results haven't been published yet
        assert!(!trial.is_published, E_ALREADY_PUBLISHED);
        
        // Record the results hash and publication timestamp
        trial.results_hash = results_hash;
        trial.publication_time = timestamp::now_seconds();
        trial.is_published = true;
    }
}