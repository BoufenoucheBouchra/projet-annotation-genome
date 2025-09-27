#!/usr/bin/perl
use strict;
use warnings;

# Vérifier le nombre d'arguments
if (@ARGV != 2) {
    die "Usage: perl script.pl <input_file> <sequence_name>\n";
}

# Assigner les arguments à des variables
my $input_file = $ARGV[0];
my $sequence_name = $ARGV[1];

# Ouvre le fichier d'entrée
open my $fh, '<', $input_file or die "Impossible d'ouvrir le fichier : $!";

my %cds_data;  # Pour stocker les données des CDS

# Lit le fichier ligne par ligne
while (my $line = <$fh>) {
    # Ignore les lignes jusqu'à la section des prédictions
    if ($line =~ /^Left/) {
        <$fh>; <$fh>; <$fh>;  # Ignore les lignes d'en-tête
        next;
    }

    # Capture les données de prévision
    if ($line =~ /^\s*(\d+)\s+(\d+)\s+(direct|complement)\s+fr\s+\d+\s+(\d+\.\d+)\s+(\d+\.\d+)/) {
        my ($left_end, $right_end, $strand, $coding_prob) = ($1, $2, $3, $4);

        # Convertit le brin
        my $gff_strand = ($strand eq 'direct') ? '+' : '-';

        # Stocke les données dans un hash
        push @{$cds_data{$right_end}}, {
            left_end => $left_end,
            coding_prob => $coding_prob,
            strand => $gff_strand,
        };
    }
}

# Génération des lignes GFF
my $cds_count = 1;  # Compteur pour les CDS

foreach my $right_end (sort { $a <=> $b } keys %cds_data) {
    my $version_count = 1;  # Compteur pour les versions
    foreach my $cds_info (@{$cds_data{$right_end}}) {
        my $left_end = $cds_info->{left_end};
        my $coding_prob = $cds_info->{coding_prob};
        my $gff_strand = $cds_info->{strand};

        # Génère la ligne GFF pour le CDS
        my $gff_line = "$sequence_name\tGenMark\tCDS\t$left_end\t$right_end\t$coding_prob\t$gff_strand\t.\tgene GM_CDS_$cds_count.$version_count";
        print "$gff_line\n";

        # Vérifie et gère les codons ATG pour chaque CDS
        my $atg_start = $left_end;  # Position de départ
        my $atg_end = $atg_start + 2;  # Codon ATG occupe 3 positions

        # Génère la ligne GFF pour le codon ATG
        my $gff_atg_line = "$sequence_name\tGenMark\tATG\t$atg_start\t$atg_end\t0.00\t$gff_strand\t.\t";
        print "$gff_atg_line\n";

        $version_count++;  # Incrémente le compteur de version
    }
    $cds_count++;  # Incrémente le compteur de CDS après avoir traité toutes les versions
}

# Ferme le fichier
close $fh;
