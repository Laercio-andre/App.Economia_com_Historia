// src/main/java/com/economiangola/repository/EntradaRankingRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.EntradaRanking;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EntradaRankingRepository extends JpaRepository<EntradaRanking, Long> {

    Page<EntradaRanking> findByRankingIdOrderByPosicaoAsc(Long rankingId, Pageable pageable);

    Optional<EntradaRanking> findByRankingIdAndUsuarioId(Long rankingId, Long usuarioId);
}
