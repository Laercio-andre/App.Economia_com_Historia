// src/main/java/com/economiangola/repository/RankingRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Ranking;
import com.economiangola.domain.enums.TipoRanking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RankingRepository extends JpaRepository<Ranking, Long> {

    Optional<Ranking> findByTipoRanking(TipoRanking tipoRanking);

    Optional<Ranking> findByTipoRankingAndQuizId(TipoRanking tipoRanking, Long quizId);

    List<Ranking> findByTipoRankingIn(List<TipoRanking> tipos);
}
