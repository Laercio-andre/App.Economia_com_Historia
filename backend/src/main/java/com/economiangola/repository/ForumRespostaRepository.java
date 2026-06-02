// src/main/java/com/economiangola/repository/ForumRespostaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ForumResposta;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ForumRespostaRepository extends JpaRepository<ForumResposta, Long> {

    Page<ForumResposta> findByTopicoIdAndPaiIsNullAndDeletedAtIsNull(Long topicoId, Pageable pageable);

    Optional<ForumResposta> findByIdAndDeletedAtIsNull(Long id);
}
